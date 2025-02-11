part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class LoginRequest extends AuthEvent {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
}

class SignUpRequest extends AuthEvent {
  final String email;
  final String password;

  SignUpRequest({required this.email, required this.password});
}

class LogoutRequest extends AuthEvent {}