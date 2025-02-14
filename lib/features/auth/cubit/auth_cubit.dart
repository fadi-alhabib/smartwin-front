import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      emit(AuthSuccess('User Registered Successfully.', response.data));
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
      emit(AuthSendOTPSuccess('OTP Sent Successfully.', response.data));
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
      await CacheHelper.setCache(
          key: 'token', value: response!.data['data']['token']);
      await CacheHelper.setCache(
          key: 'user', value: json.encode(response.data['data']['user']));
      final UserModel user = UserModel.fromJson(response.data['data']['user']);
      print(response.data);
      print(response.data['data']['token']);
      emit(AuthVerifyOTPSuccess('OTP verified successfully.', user));
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(AuthVerifyOTPError(_handleError(e)));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthError('Google sign-in canceled.'));
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final response = await DioHelper.postData(
        path: '/auth/google-callback',
        data: {'access_token': googleAuth.accessToken},
      );
      await CacheHelper.setCache(
          key: 'token', value: response!.data['data']['token']);
      await CacheHelper.setCache(
          key: 'user', value: json.encode(response.data['data']['user']));
      final UserModel user = UserModel.fromJson(response.data['data']['user']);
      log(response.data.toString());
      emit(AuthSuccess('Google Sign-In Successful.', user.toJson()));
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(AuthError(_handleError(e)));
    }
  }

  String _handleError(Object e) {
    if (e is DioException) {
      return e.response?.data['message'] ?? 'An unexpected error occurred.';
    }
    return 'An unexpected error occurred.';
  }
}
