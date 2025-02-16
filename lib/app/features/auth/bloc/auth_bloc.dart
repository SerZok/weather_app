import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/services/auth_service.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/app/features/favorite/favorite.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = getIt<AuthService>();

  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthLogIn>(_onLogIn);
    on<AuthLogOut>(_onLogOut);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signUp(email: event.email, password: event.password);
      final user = _authService.getCurrentUser(); // Получаем текущего пользователя
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid));
        _loadFavorites(user.uid);
      } else {
        emit(AuthFailure(error: "Ошибка регистрации"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogIn(AuthLogIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(email: event.email, password: event.password);
      final user = _authService.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid));
        _loadFavorites(user.uid);
      } else {
        emit(AuthFailure(error: "Ошибка входа"));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(userId: user.uid));
      _loadFavorites(user.uid);
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.logOut();
      emit(AuthUnauthenticated());

      // Очищаем избранное после выхода
      final favoritesBloc = getIt<FavoritesBloc>();
      favoritesBloc.add(ClearFavorites());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  /// Метод для загрузки избранных статей после аутентификации
  void _loadFavorites(String userId) {
    final favoritesBloc = getIt<FavoritesBloc>();
    favoritesBloc.add(LoadFavorites());
  }
}
