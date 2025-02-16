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

class TransferLoading extends HomeState {}

class TransferSuccess extends HomeState {
  final TransferModel transfer;
  const TransferSuccess(this.transfer);

  @override
  List<Object?> get props => [transfer];
}

class TransferFailure extends HomeState {
  final String error;
  const TransferFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileImageUploading extends HomeState {}

class ProfileImageUploaded extends HomeState {
  final String imageUrl;
  const ProfileImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileImageError extends HomeState {
  final String message;
  const ProfileImageError(this.message);

  @override
  List<Object> get props => [message];
}
