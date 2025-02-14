import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import '../../../../../common/utils/dio_helper.dart';

part 'create_store_state.dart';

class CreateStoreCubit extends Cubit<CreateStoreState> {
  CreateStoreCubit() : super(CreateStoreInitial());
  CreateStoreCubit get(context) => BlocProvider.of(context);
  createStore(
      {required String name,
      required String type,
      required String country,
      required String address,
      required String phone,
      required File image}) async {
    emit(CreateStoreLoadingState());
    DioHelper.postData(
        path: "stores/",
        data: FormData.fromMap({
          "name": name,
          "type": type,
          "country": country,
          "address": address,
          "phone": phone,
          "image": await MultipartFile.fromFile(image.path),
        })).then((value) {
      print(value?.data);
      emit(CreateStoreSuccessState());
    }).catchError((error) {
      print(error.response.data);
      emit(CreateStoreErrorState());
    });
  }
}
