part of 'create_store_cubit.dart';

@immutable
sealed class CreateStoreState {}

final class CreateStoreInitial extends CreateStoreState {}

class CreateStoreLoadingState extends CreateStoreState {}

class CreateStoreSuccessState extends CreateStoreState {}

class CreateStoreErrorState extends CreateStoreState {}

class UpdateStoreLoadingState extends CreateStoreState {}

class UpdateStoreSuccessState extends CreateStoreState {}

class UpdateStoreErrorState extends CreateStoreState {}
