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
    try {
      await DioHelper.postData(
          path: "stores",
          data: FormData.fromMap({
            "name": name,
            "type": type,
            "country": country,
            "address": address,
            "phone": phone,
            "image": await MultipartFile.fromFile(image.path),
          }));
      emit(CreateStoreSuccessState());
    } on DioException {
      emit(CreateStoreErrorState());
    }
  }

  updateStore(
      {String? name,
      String? type,
      String? country,
      String? address,
      String? phone,
      required String id,
      File? image}) async {
    emit(UpdateStoreLoadingState());

    DioHelper.postData(
            path: "stores/$id",
            data: FormData.fromMap(image != null
                ? {
                    "name": name,
                    "type": type,
                    "country": country,
                    "address": address,
                    "phone": phone,
                    "image": await MultipartFile.fromFile(image.path),
                  }
                : {
                    "name": name,
                    "type": type,
                    "country": country,
                    "address": address,
                    "phone": phone,
                  }))
        .then((value) {
      emit(UpdateStoreSuccessState());
    }).catchError((error) {
      emit(UpdateStoreErrorState());
    });
  }
}
