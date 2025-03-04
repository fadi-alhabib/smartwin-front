import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/dio_helper.dart';
import '../models/all_stores_model.dart';
import '../models/mystore_model.dart';
import '../models/products_details_model.dart';
import '../models/products_model.dart';
import '../models/produt_rating_model.dart';
import '../models/store_rating_model.dart';
import 'stores_states.dart';

class AllStoresCubit extends Cubit<AllStoresStates> {
  AllStoresCubit() : super(AllStoresInitial());
  AllStoresCubit get(context) => BlocProvider.of(context);

  List<Stores>? allStoresModel;
  int currentPage = 1; // Keep track of the current page.
  bool isLoading = false; // Prevent multiple calls at the same time.

  Future<void> getAllStores() async {
    if (isLoading) return; // Avoid multiple API calls.
    isLoading = true;
    emit(AllStoresLoadingState());

    try {
      final value = await DioHelper.getData(
        path: "stores/",
        queryParameters: {
          'page': currentPage.toString(), // Send current page as a parameter.
          'per_page': '8', // Limit results per page.
        },
      );
      List<dynamic> jsonStores = value!.data['data'];
      List<Stores> stores =
          jsonStores.map((stor) => Stores.fromJson(stor)).toList();
      if (allStoresModel == null) {
        allStoresModel = stores;
      } else {
        allStoresModel!.addAll(stores);
      }
      emit(AllStoresSuccessState());
      currentPage++; // Increase the page number for the next call.
    } on DioException catch (error) {
      print(error.response!.data);
      emit(AllStoresErrorState());
    } finally {
      isLoading = false; // Reset the loading flag after the request completes.
    }
  }

  UeserStoreModle? storeDetails;
  Future<void> getStore(id) async {
    emit(GetStoreLoadingState());
    try {
      final response = await DioHelper.getData(path: "stores/$id");
      print(response!.data);
      storeDetails = UeserStoreModle.fromJson(response.data);
      emit(GetStoreSuccessState());
    } catch (error) {
      rethrow;
      emit(GetStoreErrorState());
    }
  }

  AllProductsModel? allProductsModel;
  int currentProductPage = 1;

  Future<void> getAllProducts({bool loadMore = false}) async {
    if (!loadMore) {
      currentProductPage =
          1; // Reset the page when it's not a "load more" request.
    }

    emit(AllStoresLoadingState());
    try {
      final value = await DioHelper.getData(
        path: 'products/',
        queryParameters: {'page': currentProductPage, 'per_page': 8},
      );
      var newProducts = AllProductsModel.fromJson(value?.data);
      if (loadMore) {
        allProductsModel?.products
            .addAll(newProducts.products); // Append new products.
      } else {
        allProductsModel = newProducts; // Replace with the fresh list.
      }
      emit(AllStoresSuccessState());
      currentProductPage++; // Increment the page for the next request.
    } catch (error) {
      emit(AllStoresErrorState());
    }
  }

  UeserStoreModle? ueserStoreModle;
  bool noStore = false;
  Future<void> getUserStore() async {
    ueserStoreModle = null;
    emit(UserStoreLodingState());
    try {
      final value = await DioHelper.getAuthData(path: "stores/me");
      ueserStoreModle = UeserStoreModle.fromJson(value?.data);
      emit(UserStoreSuccessState());
    } on DioException catch (error) {
      noStore = error.response!.statusCode == 404;
      emit(UserStoreErroeState(noStore));
    }
  }

  ProductDetailsModel? productDetailsModel;
  Future<void> getProductDetails({required int? id}) async {
    productDetailsModel = null;
    emit(GetProductDetailsLodingState());
    try {
      final value = await DioHelper.getData(path: "products/$id");
      productDetailsModel = ProductDetailsModel.fromJson(value?.data);
      emit(GetProductDetailsSuccessState());
    } on DioException catch (error) {
      print(error.response!.data);
      emit(GetProductDetailsErroeState());
    }
  }

  RatingModel? ratingModel;
  Future<void> ratingProduct({required int id, required int rating}) async {
    emit(RatingProductLodingState());
    try {
      final value = await DioHelper.postData(
        path: 'product-ratings',
        data: {
          'product_id': id,
          'rating': rating,
        },
      );
      ratingModel = RatingModel.fromJson(value?.data);
      emit(RatingProductSuccessState(id));
    } catch (error) {
      log(error.toString());
    }
  }

  StoreRatingModel? storeRatingModel;
  Future<void> ratingStore({required int? id, required int rating}) async {
    emit(RatingSroreLodingState());
    try {
      final value = await DioHelper.postData(
        path: "rate/store/$id",
        data: FormData.fromMap({"rating": rating}),
      );
      ratingModel = RatingModel.fromJson(value?.data);
      emit(RatingSroreSuccessState());
    } catch (error) {
      emit(RatingSroreErroeState());
    }
  }
}
