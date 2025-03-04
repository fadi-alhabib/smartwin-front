import 'dart:developer';

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
      emit(CreateProductSuccessState());
    }).catchError((error) {
      emit(CreateProductFailureState());
    });
  }

  updateProduct(
      {required String name,
      required String description,
      required String price,
      required String id}) {
    emit(UpdateProductLoadingState());
    DioHelper.postData(
        path: "products/$id",
        data: FormData.fromMap({
          "name": name,
          "description": description,
          "price": price,
        })).then((value) {
      emit(UpdateProductSuccessState());
    }).catchError((error) {
      emit(UpdateProductFailureState());
    });
  }

  Future<void> deleteImage(int id) async {
    emit(ProductImageLoading());
    try {
      final Response response =
          await DioHelper.dio!.delete('product-images/$id');
      if (response.statusCode == 200) {
        emit(ProductImageOperationSuccess(
            message: 'Image deleted successfully.'));
      } else {
        emit(ProductImageOperationFailure(
            error: 'Failed to delete image. Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(ProductImageOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteBatchImages(List<int> imageIds) async {
    emit(ProductImageLoading());
    try {
      final Response response = await DioHelper.dio!.delete(
        'product-images/batch',
        data: {'images': imageIds},
      );
      if (response.statusCode == 200) {
        emit(ProductImageOperationSuccess(
            message: 'Batch images deleted successfully.'));
      } else {
        emit(ProductImageOperationFailure(
            error:
                'Failed to delete batch images. Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductImageOperationFailure(error: e.toString()));
    }
  }

  Future<void> addImageToProduct(String imagePath, int productId) async {
    emit(ProductImageLoading());
    try {
      FormData formData = FormData.fromMap({
        'product_id': productId,
        'image': await MultipartFile.fromFile(imagePath),
      });
      final Response response = await DioHelper.dio!.post(
        'product-images',
        data: formData,
      );
      if (response.statusCode == 201) {
        emit(
            ProductImageOperationSuccess(message: 'Image added successfully.'));
      } else {
        emit(ProductImageOperationFailure(
            error: 'Failed to add image. Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      emit(ProductImageOperationFailure(error: e.toString()));
    }
  }

  Future<void> addBatchImages(List<String> imagePaths, int productId) async {
    emit(ProductImageLoading());
    try {
      List<MultipartFile> imageFiles = [];
      for (String path in imagePaths) {
        imageFiles.add(await MultipartFile.fromFile(path));
      }

      FormData formData = FormData.fromMap({
        'product_id': productId,
        'images': imageFiles,
      });
      final Response response = await DioHelper.dio!.post(
        'product-images/batch',
        data: formData,
      );
      if (response.statusCode == 201) {
        emit(ProductImageOperationSuccess(
            message: 'Batch images added successfully.'));
      } else {
        emit(ProductImageOperationFailure(
            error:
                'Failed to add batch images. Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductImageOperationFailure(error: e.toString()));
    }
  }
}
