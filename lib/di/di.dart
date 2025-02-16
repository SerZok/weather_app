import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/data/dio/set_up.dart';
import 'package:weather_app/app/services/auth_service.dart';
import 'package:weather_app/app/features/auth/bloc/auth_bloc.dart';
import 'package:weather_app/app/features/favorite/bloc/favorites_bloc.dart';
import '../domain/domain.dart';
import 'package:firebase_auth/firebase_auth.dart';

final getIt = GetIt.instance;
final Dio dio = Dio();
final talker = TalkerFlutter.init();
final CityService cityService = CityService();

class CityService {
  final List<String> _cities = ['Москва'];
  
  List<String> get cities => _cities;

  void addCity(String city) {
    _cities.add(city);
  }

  void removeCity(String city) {
    _cities.remove(city);
  }
}

Future<void> setupLocator() async {
  setUpDio();
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton(talker);
  getIt.registerSingleton(CityService());
  getIt.registerSingleton(TopNewsRepository(dio: getIt<Dio>(), cityService: cityService));
  getIt.registerSingleton(HomeBloc(getIt.get<TopNewsRepository>()));
  getIt.registerSingleton(AboutBloc(getIt.get<TopNewsRepository>()));

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AuthBloc>(AuthBloc());

  final user = FirebaseAuth.instance.currentUser;
   getIt.registerSingleton<FavoritesBloc>(
    FavoritesBloc(userId: user?.uid, topNewsRepository: getIt<TopNewsRepository>()),
  );
}