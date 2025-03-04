import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/features/rooms/models/room_model.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit() : super(RoomInitial());

  Future<void> getRooms() async {
    emit(RoomsLoading());
    try {
      final response = await DioHelper.getAuthData(path: '/rooms');
      final List<dynamic> data = response!.data['data'];
      final List<RoomModel> rooms =
          data.map<RoomModel>((room) => RoomModel.fromJson(room)).toList();
      log(rooms.toString());
      emit(RoomsSuccess(rooms));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  RoomModel? myRoom;
  Future<void> getMyRoom({int? id}) async {
    emit(GetMyRoomLoading());
    try {
      late Response? response;
      if (id != null) {
        response = await DioHelper.getAuthData(path: '/rooms/$id');
      } else {
        response = await DioHelper.getAuthData(path: '/rooms/me');
      }
      final room = RoomModel.fromJson(response!.data['data']);
      myRoom = room;
      log(room.toString());
      emit(GetMyRoomSuccess(room));
    } on DioException catch (e) {
      myRoom = null;
      log(e.toString());
      emit(GetMyRoomError(e.toString()));
    }
  }

  Future<void> createRoom({
    required String name,
    required XFile imageFile,
  }) async {
    emit(RoomLoading());
    try {
      final formData = FormData.fromMap({
        'name': name,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      final room = await DioHelper.postData(
        path: '/rooms',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );
      emit(RoomCreatedSuccess(room));
      getMyRoom();
    } on DioException catch (e) {
      if (e.response != null) {
        log(e.response!.data.toString());
      } else {
        log(e.toString());
      }
      emit(RoomError(e.response?.data['message'] ?? 'حدث خطأ ما'));
    } catch (e) {
      emit(const RoomError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> purchaseTime({
    required int roomId,
    required int minutes,
    required int price,
  }) async {
    emit(TimePurchaseLoading());
    try {
      final response = await DioHelper.postData(
        path: '/rooms/$roomId/time-purchase',
        data: {
          'minutes': minutes,
          'price': price,
        },
      );

      if (response!.statusCode == 200) {
        // Successful purchase
        emit(TimePurchaseSuccess());
      } else {
        // Try to extract the error message from the API response
        final error = (response.data is Map<String, dynamic>)
            ? response.data['error']
            : null;
        emit(TimePurchaseError(error ?? 'Unknown error occurred'));
      }
    } on DioException catch (e) {
      // Handle Dio exceptions: try to get the error message from the response data
      String errorMessage = 'An error occurred';
      if (e.response != null && e.response?.data is Map) {
        errorMessage = e.response?.data['error'] ?? errorMessage;
      } else {
        errorMessage = e.message!;
      }
      emit(TimePurchaseError(errorMessage));
    } catch (e) {
      emit(TimePurchaseError(e.toString()));
    }
  }

  Future<void> fetchActiveUsers() async {
    emit(ActiveUsersLoading());
    try {
      final Response? response = await DioHelper.getAuthData(
        path: 'messages/rooms/active-users',
      );
      final List<dynamic> usersData = response!.data['data'];
      final List<UserModel> users = usersData
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
      emit(ActiveUsersLoaded(users: users));
    } on DioException catch (e) {
      emit(ActiveUsersError(message: e.toString()));
    }
  }
}
