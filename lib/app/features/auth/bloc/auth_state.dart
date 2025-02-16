part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  
  const AuthAuthenticated({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
