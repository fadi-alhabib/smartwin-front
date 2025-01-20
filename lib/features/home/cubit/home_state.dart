part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeDataLoading extends HomeState {}

final class HomeDataSuccess extends HomeState {
  final HomeDataModel data;

  const HomeDataSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

final class HomeDataError extends HomeState {
  final String error;

  const HomeDataError(this.error);

  @override
  List<Object?> get props => [error];
}
