part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  const AuthSuccess(this.message, [this.data]);

  @override
  List<Object?> get props => [message, data];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthSendOTPLoading extends AuthState {}

class AuthSendOTPSuccess extends AuthState {
  final String message;
  final Map<String, dynamic>? data;

  const AuthSendOTPSuccess(this.message, [this.data]);

  @override
  List<Object?> get props => [message, data];
}

class AuthSendOTPError extends AuthState {
  final String error;

  const AuthSendOTPError(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthVerifyOTPLoading extends AuthState {}

class AuthVerifyOTPSuccess extends AuthState {
  final String message;
  final UserModel? user;

  const AuthVerifyOTPSuccess(this.message, [this.user]);

  @override
  List<Object?> get props => [message, user];
}

class AuthVerifyOTPError extends AuthState {
  final String error;

  const AuthVerifyOTPError(this.error);

  @override
  List<Object?> get props => [error];
}

// final class RegisterLoadingState extends AuthState {}

// final class RegisterDoneState extends AuthState {}

// final class RegisterFailureState extends AuthState {}

// final class VerificationLoadingState extends AuthState {}

// final class VerificationDoneState extends AuthState {}

// final class VerificationFailureState extends AuthState {}
