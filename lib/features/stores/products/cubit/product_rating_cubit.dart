import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/auth/models/user_model.dart';

part 'product_rating_state.dart';

class ProductRatingCubit extends Cubit<ProductRatingState> {
  ProductRatingCubit() : super(ProductRatingInitial());

  Future<void> createRating({
    required int productId,
    required int rating,
    String? review,
  }) async {
    emit(ProductRatingLoading());
    try {
      final Response? response = await DioHelper.postData(
        path: 'product-ratings/',
        data: {
          'product_id': productId,
          'rating': rating,
          'review': review,
        },
      );
      if (response != null && response.statusCode == 201) {
        emit(ProductRatingOperationSuccess(
            message: 'Rating submitted successfully.'));
      } else {
        emit(ProductRatingOperationFailure(
          error:
              'Failed to submit rating: ${response?.data ?? 'Unknown error'}',
        ));
      }
    } catch (e) {
      emit(ProductRatingOperationFailure(error: e.toString()));
    }
  }

  Future<void> getRatings(int productId) async {
    emit(ProductRatingLoading());
    try {
      final Response? response = await DioHelper.getData(
        path: 'product-ratings/$productId',
      );
      if (response != null && response.statusCode == 200) {
        final ratings = response.data; // Expected to be a list of ratings.
        emit(ProductRatingLoaded(ratings: ratings));
      } else {
        emit(ProductRatingOperationFailure(
          error:
              'Failed to fetch ratings: ${response?.data ?? 'Unknown error'}',
        ));
      }
    } catch (e) {
      emit(ProductRatingOperationFailure(error: e.toString()));
    }
  }

  Future<void> updateRating({
    required int id,
    int? rating,
    String? review,
  }) async {
    emit(ProductRatingLoading());
    try {
      final Response response = await DioHelper.dio!.patch(
        'product-ratings/$id',
        data: {
          if (rating != null) 'rating': rating,
          if (review != null) 'review': review,
        },
      );
      if (response.statusCode == 200) {
        emit(ProductRatingOperationSuccess(
            message: 'Rating updated successfully.'));
      } else {
        emit(ProductRatingOperationFailure(
          error: 'Failed to update rating: ${response.data}',
        ));
      }
    } catch (e) {
      emit(ProductRatingOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteRating(int id) async {
    emit(ProductRatingLoading());
    try {
      final Response response =
          await DioHelper.dio!.delete('product-ratings/$id');
      if (response.statusCode == 200) {
        emit(ProductRatingOperationSuccess(
            message: 'Rating deleted successfully.'));
      } else {
        emit(ProductRatingOperationFailure(
          error: 'Failed to delete rating: ${response.data}',
        ));
      }
    } catch (e) {
      emit(ProductRatingOperationFailure(error: e.toString()));
    }
  }
}
