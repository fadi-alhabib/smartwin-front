import 'package:bloc/bloc.dart';
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

  void getAllStores() {
    if (isLoading) return; // Avoid multiple API calls.
    isLoading = true;
    emit(AllStoresLoadingState());

    DioHelper.getData(path: "stores/", queryParameters: {
      'page': currentPage.toString(), // Send current page as a parameter.
      'per_page': '8', // Limit results per page (you can make this dynamic).
    }).then((value) {
      List<dynamic> jsonStores = value!.data['data'];
      List<Stores> stores =
          jsonStores.map((stor) => Stores.fromJson(stor)).toList();
      if (allStoresModel == null) {
        allStoresModel = stores;
      } else {
        allStoresModel!.addAll(stores);
      }
      print(value.data);
      emit(AllStoresSuccessState());
      currentPage++; // Increase the page number for the next call.
    }).catchError((error) {
      emit(AllStoresErrorState());
    }).whenComplete(() {
      isLoading = false; // Reset the loading flag after the request completes.
    });
  }

  UeserStoreModle? storeDetails;
  getStore(id) {
    emit(GetStoreLoadingState());
    DioHelper.getData(path: "stores/$id").then((value) {
      storeDetails = UeserStoreModle.fromJson(value?.data);
      emit(GetStoreSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetStoreErrorState());
    });
  }

  AllProductsModel? allProductsModel;

  int currentProductPage = 1;

  void getAllProducts({bool loadMore = false}) {
    if (!loadMore) {
      currentProductPage =
          1; // Reset the page when it's not a "load more" request.
    }

    emit(AllStoresLoadingState());

    DioHelper.getData(
      path: 'products/',
      queryParameters: {'page': currentProductPage, 'per_page': 8},
    ).then((value) {
      var newProducts = AllProductsModel.fromJson(value?.data);
      if (loadMore) {
        allProductsModel?.products
            .addAll(newProducts.products); // Append new products
      } else {
        allProductsModel = newProducts; // Replace with the fresh list
      }
      emit(AllStoresSuccessState());
      currentProductPage++; // Increment the page for the next request
    }).catchError((error) {
      throw error;
      emit(AllStoresErrorState());
    });
  }

  UeserStoreModle? ueserStoreModle;
  bool noStore = false;
  getUserStore() {
    emit(UserStoreLodingState());
    DioHelper.getAuthData(path: "stores/me").then((value) {
      ueserStoreModle = UeserStoreModle.fromJson(value?.data);
      emit(UserStoreSuccessState());
    }).catchError((error) {
      print(error.toString());
      noStore = error.response.statusCode == 404;
      emit(UserStoreErroeState(noStore));
    });
  }

  ProductDetailsModel? productDetailsModel;
  getProductDetails({required int? id}) {
    productDetailsModel = null;
    emit(GetProductDetailsLodingState());
    DioHelper.getData(path: "products/$id").then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value?.data);
      emit(GetProductDetailsSuccessState());
      // print(value?.data);
    }).catchError((error) {
      print(error.toString());
      emit(GetProductDetailsErroeState());
    });
  }

  RatingModel? ratingModel;
  ratingProduct({required int? id, required int rating}) {
    emit(RatingProductLodingState());
    DioHelper.postData(
        path: "rate/product/$id",
        data: FormData.fromMap({"rating": rating})).then((value) {
      ratingModel = RatingModel.fromJson(value?.data);
      emit(RatingProductSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  StoreRatingModel? storeRatingModel;
  ratingStore({required int? id, required int rating}) {
    emit(RatingSroreLodingState());
    DioHelper.postData(
        path: "rate/store/$id",
        data: FormData.fromMap({"rating": rating})).then((value) {
      ratingModel = RatingModel.fromJson(value?.data);
      print(value?.data);
      emit(RatingSroreSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(RatingSroreErroeState());
    });
  }
}
