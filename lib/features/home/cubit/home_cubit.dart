import 'dart:developer';

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
    required int userId,
    required String country,
    required String phone,
    required int points,
  }) async {
    emit(TransferLoading());
    try {
      final response = await DioHelper.postData(
        path: 'transfer', // Adjust this path if needed.
        data: {
          'user_id': userId,
          'country': country,
          'phone': phone,
          'points': points,
        },
      );

      // Check for a successful response.
      if (response != null && response.statusCode == 201) {
        // Assuming the API returns the created transfer in JSON format.
        final transfer = TransferModel.fromJson(response.data);
        emit(TransferSuccess(transfer));
      } else {
        // Extract error message if available.
        final errorMessage =
            response?.data['message'] ?? 'Failed to create transfer';
        emit(TransferFailure(errorMessage));
      }
    } catch (error) {
      emit(TransferFailure(error.toString()));
    }
  }
}
