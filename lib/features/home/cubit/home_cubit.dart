import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/home/models/home_data_model.dart';
import 'package:sw/features/home/models/transfer_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeDataLoading());
    try {
      final response = await DioHelper.getAuthData(path: '/ads/home');
      log(response!.data.toString());
      emit(HomeDataSuccess(HomeDataModel.fromJson(response.data['data'])));
    } on DioException catch (e) {
      log(e.toString());
      emit(HomeDataError(e.response!.data.toString()));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createTransfer({
    required String country,
    required String phone,
    required int points,
  }) async {
    emit(TransferLoading());
    try {
      final response = await DioHelper.postData(
        path: 'transfers',
        data: {
          'country': country,
          'phone': phone,
          'points': points,
        },
      );
      final transfer = TransferModel.fromJson(response!.data['data']);
      emit(TransferSuccess(transfer));
    } on DioException catch (error) {
      print(error.response!.data);
      final errorMessage =
          error.response?.data['message'] ?? 'Failed to create transfer';
      emit(TransferFailure(errorMessage));
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    emit(ProfileImageUploading());

    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(imageFile.path,
            filename: "profile.jpg"),
      });

      Response? response = await DioHelper.postData(
        path: 'auth/profile-image',
        data: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      print(response!.data);
      if (response.statusCode == 200) {
        String imageUrl = response.data['data']["image"];
        emit(ProfileImageUploaded(imageUrl));
      } else {
        emit(ProfileImageError("Upload failed"));
      }
    } on DioException catch (e) {
      print(e.response!.data.toString());
      emit(ProfileImageError("Error: ${e.toString()}"));
    }
  }
}
