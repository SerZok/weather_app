part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Article> favorites;
  FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class ClearFavorites extends FavoritesEvent {}