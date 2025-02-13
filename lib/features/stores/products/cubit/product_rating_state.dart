part of 'product_rating_cubit.dart';

abstract class ProductRatingState extends Equatable {
  const ProductRatingState();

  @override
  List<Object?> get props => [];
}

class ProductRatingInitial extends ProductRatingState {}

class ProductRatingLoading extends ProductRatingState {}

class ProductRatingOperationSuccess extends ProductRatingState {
  final String message;
  const ProductRatingOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductRatingOperationFailure extends ProductRatingState {
  final String error;
  const ProductRatingOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ProductRatingLoaded extends ProductRatingState {
  final List<dynamic> ratings;
  const ProductRatingLoaded({required this.ratings});

  @override
  List<Object?> get props => [ratings];
}
