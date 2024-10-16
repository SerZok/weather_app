import 'dart:async';
import 'package:dio/dio.dart';
import 'package:weather_app/app/data/data.dart';
import 'package:weather_app/app/data/endpoints.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/domain.dart';

class TopNewsRepository extends TopNewsRepositoryIterface {
  TopNewsRepository({required this.dio, required this.cityService});
  final Dio dio;
  CityService cityService;  // Сервис для работы с городами

  @override
  Future<List<Article>> getWeather() async {
    List<Article> articles = [];

    // Запрашиваем текущий список городов из сервиса
    List<String> cities = cityService.cities;
    
    for (String city in cities) {
      try {
        final Response response = await dio.get(
          dio.options.baseUrl + Endpoints.currentWeather,
          queryParameters: {
            'q': city,
            'aqi': 'no',
          },
        );
        final currentWeatherData = response.data;
        articles.add(Article.fromJson(currentWeatherData));  // Добавляем в список
      } on DioException catch (e) {
        print("Ошибка при получении данных для города $city: ${e.message}");
      }
    }
    return articles;
  }
}
