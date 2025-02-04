import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/home/models/home_data_model.dart';

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
    }
  }
}
