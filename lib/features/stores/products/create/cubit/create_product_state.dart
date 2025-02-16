part of 'create_product_cubit.dart';

@immutable
sealed class CreateProductState {}

final class CreateProductInitial extends CreateProductState {}

class CreateProductLoadingState extends CreateProductState {}

class CreateProductSuccessState extends CreateProductState {}

class CreateProductFailureState extends CreateProductState {}

class UpdateProductLoadingState extends CreateProductState {}

class UpdateProductSuccessState extends CreateProductState {}

class UpdateProductFailureState extends CreateProductState {}

class ProductImageLoading extends CreateProductState {}

class ProductImageOperationSuccess extends CreateProductState {
  final String message;

  ProductImageOperationSuccess({required this.message});
}

class ProductImageOperationFailure extends CreateProductState {
  final String error;

  ProductImageOperationFailure({required this.error});
}
