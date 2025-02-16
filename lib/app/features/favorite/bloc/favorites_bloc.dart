import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/domain/domain.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TopNewsRepository _topNewsRepository;
  String? userId;

  FavoritesBloc({required this.userId, required TopNewsRepository topNewsRepository})
      : _topNewsRepository = topNewsRepository,
        super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);

    if (userId != null) {
      add(LoadFavorites());
    }
  }

  void updateUserId(String newUserId) {
    userId = newUserId;
    add(LoadFavorites());
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoritesState> emit) async {
    if (userId == null) return;
    
    emit(FavoritesLoading());
    try {
      final snapshot = await _firestore.collection('users').doc(userId).collection('favorites').get();
      final List<String> favoriteCities = snapshot.docs.map((doc) => doc.id).toList();
      final List<Article> articles = await _topNewsRepository.getWeatherForCities(favoriteCities);

      emit(FavoritesLoaded(articles));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

 void _onAddToFavorites(AddToFavorites event, Emitter<FavoritesState> emit) async {
    if (userId == null) return;

    try {
      // Добавляем город в избранное в Firestore
      await _firestore.collection('users').doc(userId).collection('favorites').doc(event.itemId).set({});
      add(LoadFavorites()); // Перезагружаем избранное
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

void _onRemoveFromFavorites(RemoveFromFavorites event, Emitter<FavoritesState> emit) async {
    if (userId == null) return;

    try {
      // Удаляем город из избранного в Firestore
      await _firestore.collection('users').doc(userId).collection('favorites').doc(event.itemId).delete();
      add(LoadFavorites()); // Перезагружаем избранное
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  void _onClearFavorites(ClearFavorites event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoaded([]));
  }
}
