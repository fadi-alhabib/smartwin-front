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

  AllStoresModel? allStoresModel;
  getAllStores() {
    emit(AllStoresLoadingState());
    DioHelper.getData(path: "stores/").then((value) {
      allStoresModel = AllStoresModel.fromJson(value?.data);
      emit(AllStoresSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AllStoresErrorState());
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
  getAllProducts() {
    emit(AllStoresLoadingState());
    DioHelper.getData(path: "products/").then((value) {
      allProductsModel = AllProductsModel.fromJson(value?.data["data"]);
      emit(AllProductsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AllProductsErroeState());
    });
  }

  UeserStoreModle? ueserStoreModle;
  bool noStore = false;
  getUserStore() {
    emit(UserStoreLodingState());
    DioHelper.getData(path: "stores/mine").then((value) {
      ueserStoreModle = UeserStoreModle.fromJson(value?.data);
      emit(UserStoreSuccessState());
    }).catchError((error) {
      print(error.toString());
      noStore = error.response.statusCode == 400;
      emit(UserStoreErroeState(error.response.statusCode));
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
