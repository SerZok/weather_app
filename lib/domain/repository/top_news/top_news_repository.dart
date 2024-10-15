import 'dart:async';
import 'package:dio/dio.dart';
import 'package:weather_app/app/data/data.dart';
import 'package:weather_app/app/data/endpoints.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/domain/repository/model/article.dart';

import 'top_news_repository_interface.dart';

class TopNewsRepository extends TopNewsRepositoryIterface {
  TopNewsRepository({required this.dio, required this.cities});
  final Dio dio;
  final List<String> cities;

  @override
  Future<List<Article>> getWeather() async {
    List<Article> articles = [];
    
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
        articles.add(Article.fromJson(currentWeatherData)); // Добавляем в список
      } on DioException catch (e) {
        print("Ошибка при получении данных для города $city: ${e.message}");
      }
    }
    
    return articles; // Возвращаем список со всеми данными по городам
  }
}
