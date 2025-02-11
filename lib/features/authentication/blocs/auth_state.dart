part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticatedState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticateErrorState extends AuthState {
  final String error;
  AuthenticateErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class SignUpErrorState extends AuthState {
  final String error;
  SignUpErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}