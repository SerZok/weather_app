import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/data/dio/set_up.dart';

import '../domain/domain.dart';

final getIt = GetIt.instance;
final Dio dio = Dio();
final talker = TalkerFlutter.init();
final List<String> cities = ['London','Moscow','Чебоксары'];

Future<void> setupLocator() async {
  setUpDio();
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton(talker);
  getIt.registerSingleton(TopNewsRepository(dio: getIt<Dio>(),cities: cities));
  getIt.registerSingleton(HomeBloc(getIt.get<TopNewsRepository>()));
}
