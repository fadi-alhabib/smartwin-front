import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/dio.dart';
import 'package:smartwin/stores/all_stores/cubit/stores_states.dart';
import 'package:smartwin/stores/all_stores/models/all_stores_model.dart';

class AllStoresCubit extends Cubit<AllStoresStates> {
  AllStoresCubit() : super(AllStoresInitial());
  AllStoresCubit get(context) => BlocProvider.of(context);

  AllStoresModel? allStoresModel;
  getAllStores() {
    emit(AllStoresLoadingState());
    DioHelper.getData(path: "store/").then((value) {
      allStoresModel = AllStoresModel.fromJson(value?.data);
      emit(AllStoresSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AllStoresErrorState());
    });
  }
}
