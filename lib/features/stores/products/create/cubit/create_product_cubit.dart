import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import '../../../../../common/utils/dio_helper.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());
  CreateProductCubit get(context) => BlocProvider.of(context);

  createProduct(
      {required String name,
      required String description,
      required String price,
      required dynamic image,
      required List<MultipartFile> images}) {
    emit(CreateProductLoadingState());
    DioHelper.postData(
        path: "product/create",
        data: FormData.fromMap({
          "name": name,
          "description": description,
          "price": price,
          "image": image,
          "images[]": images
        })).then((value) {
      print(value?.data);
      emit(CreateProductSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateProductFailureState());
    });
  }
}
