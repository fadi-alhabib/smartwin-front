import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sw/common/utils/dio_helper.dart';
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
        print(response!.data);
      }
      final room = RoomModel.fromJson(response!.data['data']);
      myRoom = room;
      log(room.toString());
      emit(GetMyRoomSuccess(room));
    } on DioException catch (e) {
      myRoom = null;
      log(e.response!.data.toString());
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
}
