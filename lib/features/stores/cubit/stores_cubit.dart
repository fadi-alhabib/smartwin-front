import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw/common/utils/dio_helper.dart';
import 'package:sw/features/stores/cubit/stores_states.dart';
import 'package:sw/features/stores/models/all_stores_model.dart';

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
