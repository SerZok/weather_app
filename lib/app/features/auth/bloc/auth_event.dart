part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUp({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLogIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLogOut extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}
