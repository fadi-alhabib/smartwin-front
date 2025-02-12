part of 'create_product_cubit.dart';

@immutable
sealed class CreateProductState {}

final class CreateProductInitial extends CreateProductState {}

class CreateProductLoadingState extends CreateProductState {}

class CreateProductSuccessState extends CreateProductState {}

class CreateProductFailureState extends CreateProductState {}
