import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:smartwin/common/utils/dio_helper.dart';
import 'package:smartwin/features/home/models/home_data_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeDataLoading());
    try {
      //TODO::COMPLETE THIS BY CONVERTING TO MODEL AND PASSING IT TO THE SUCCESS STATE
      final response = await DioHelper.getAuthData(path: '/ads/home');
    } on DioException catch (e) {}
  }
}
