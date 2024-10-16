import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/data/dio/set_up.dart';

import '../domain/domain.dart';

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
  getIt.registerSingleton(TopNewsRepository(dio: getIt<Dio>(), cityService:cityService));
  getIt.registerSingleton(HomeBloc(getIt.get<TopNewsRepository>()));
  getIt.registerSingleton(AboutBloc(getIt.get<TopNewsRepository>()));
}
