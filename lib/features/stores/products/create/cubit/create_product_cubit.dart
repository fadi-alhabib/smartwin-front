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
      required List<MultipartFile> images}) {
    emit(CreateProductLoadingState());
    DioHelper.postData(
        path: "products",
        data: FormData.fromMap({
          "name": name,
          "description": description,
          "price": price,
          "images[]": images
        })).then((value) {
      print(value?.data);
      emit(CreateProductSuccessState());
    }).catchError((error) {
      print(error.response.data);
      emit(CreateProductFailureState());
    });
  }
}
