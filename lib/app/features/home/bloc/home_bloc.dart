import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/app/features/favorite/favorite.dart';

part "home_event.dart";
part "home_state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TopNewsRepository topNewsRepository;
  HomeBloc(this.topNewsRepository) : super(HomeInitial()) {
    on<HomeLoad>(_homeLoad);
  }
  
  // Future<void> _homeLoad(event, emit) async {
  //   try {
  //     if (state is! HomeLoadSuccess) {
  //       emit(HomeLoadInProgress());
  //     }
  //     final articles = await topNewsRepository.getWeather();
  //     emit(HomeLoadSuccess(
  //       articles: articles,
  //     ));
  //   } catch (exception, state) {
  //     emit(HomeLoadFailure(exception: exception));
  //     talker.handle(exception, state);
  //   } finally {
  //     event.completer?.complete();
  //   }
  // }

Future<void> _homeLoad(event, emit) async {
  try {
    if (state is! HomeLoadSuccess) {
      emit(HomeLoadInProgress());
    }

 // Получаем все добавленные пользователем города
    final cityService = getIt<CityService>();
    final List<String> userCities = cityService.cities; // Города, которые добавил пользователь

    // Получаем список избранных городов
    final favoritesState = getIt<FavoritesBloc>().state;
    List<String> favoriteCities = [];
    if (favoritesState is FavoritesLoaded) {
      favoriteCities = favoritesState.favorites.map((article) => article.location.name).toList();
    }

    // Объединяем все города (избранные + просто добавленные)
    final List<String> allCities = {...userCities, ...favoriteCities}.toList(); 
    
    // Загружаем данные по этим городам
    final articles = await topNewsRepository.getWeatherForCities(allCities);

    emit(HomeLoadSuccess(articles: articles));
  } catch (exception, stackTrace) {
    emit(HomeLoadFailure(exception: exception));
    talker.handle(exception, stackTrace);
  } finally {
    event.completer?.complete();
  }
}

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
