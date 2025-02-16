part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final String itemId;
  AddToFavorites(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String itemId;
  RemoveFromFavorites(this.itemId);

  @override
  List<Object> get props => [itemId];
}
