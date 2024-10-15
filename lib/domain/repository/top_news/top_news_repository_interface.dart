import 'dart:async';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/domain/repository/model/article.dart';

abstract class TopNewsRepositoryIterface {
  Future <List<Article>> getWeather();
}
