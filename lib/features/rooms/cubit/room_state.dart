part of 'room_cubit.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

final class RoomInitial extends RoomState {}

final class RoomsLoading extends RoomState {}

final class RoomsSuccess extends RoomState {
  final List<RoomModel> data;

  const RoomsSuccess(this.data);
  @override
  List<Object?> get props => [];
}

final class RoomsError extends RoomState {
  final String error;

  const RoomsError(this.error);

  @override
  List<Object?> get props => [error];
}

final class GetMyRoomLoading extends RoomState {}

final class GetMyRoomSuccess extends RoomState {
  final RoomModel data;

  const GetMyRoomSuccess(this.data);
  @override
  List<Object?> get props => [];
}

final class GetMyRoomError extends RoomState {
  final String error;

  const GetMyRoomError(this.error);

  @override
  List<Object?> get props => [error];
}

class RoomLoading extends RoomState {}

class RoomCreatedSuccess extends RoomState {
  final dynamic room; // Replace with your Room model class

  const RoomCreatedSuccess(this.room);

  @override
  List<Object> get props => [room];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object> get props => [message];
}

class TimePurchaseLoading extends RoomState {}

class TimePurchaseSuccess extends RoomState {}

class TimePurchaseError extends RoomState {
  final String error;
  const TimePurchaseError(this.error);
}
