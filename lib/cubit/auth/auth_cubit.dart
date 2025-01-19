import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:smartwin/dio.dart';
import 'package:smartwin/models/user/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> register({
    required String fullName,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      final response = await DioHelper.postData(path: '/auth/register', data: {
        'full_name': fullName,
        'phone': phone,
      });
      log(response!.data.toString());
      emit(AuthSuccess('User Registered Successfuly.', response.data));
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(AuthError(_handleError(e)));
    }
  }

  Future<void> sendOtp(String phone) async {
    emit(AuthSendOTPLoading());
    try {
      final response = await DioHelper.postData(path: '/auth/send-otp', data: {
        'phone': phone,
      });
      log(response!.data.toString());
      emit(AuthSendOTPSuccess('OTP Sent Successfuly.', response.data));
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(AuthSendOTPError(_handleError(e)));
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    emit(AuthVerifyOTPLoading());
    try {
      final response = await DioHelper.postData(
        path: '/auth/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );
      final UserModel user = UserModel.fromJson(response!.data);
      print(response.data);
      emit(AuthVerifyOTPSuccess('OTP verified successfully.', response.data));
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(AuthVerifyOTPError(_handleError(e)));
    }
  }

  String _handleError(Object e) {
    if (e is DioException) {
      return e.response?.data['message'] ?? 'An unexpected error occurred.';
    }
    return 'An unexpected error occurred.';
  }
}
