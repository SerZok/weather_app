import 'package:flutter/material.dart';
import 'package:weather_app/app/features/about/bloc/about_bloc.dart';
import 'package:weather_app/di/di.dart';
// import 'package:go_router/go_router.dart';
// import 'package:weather_app/app/app.dart';
// import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/domain/repository/model/article.dart';
import 'package:weather_app/domain/repository/top_news/top_news_repository.dart';


class ArticleScreen extends StatelessWidget {
  ArticleScreen({super.key, required this.article});
  final Article article; // Параметр для хранения переданного объекта
  final _homeBloc = AboutBloc(getIt<TopNewsRepository>());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(article.location.name), // Отображаем название города в заголовке
          actions: [
            //RELOAD
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _homeBloc.add(const AboutLoad());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('${article.current.condition.icon}'),
              Text(
                'Страна: ${article.location.country}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Регион: ${article.location.region}', // Температура
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),
              Text(
                'Температура: ${article.current.tempC}°C', // Температура
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Сила ветра: ${article.current.windMph} м/с', // Сила ветра
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Местное время: ${article.location.localtime}', // Время
                style: TextStyle(fontSize: 16),
              ),
              // Добавьте дополнительные данные по мере необходимости
            ],
          ),
        ),
      ),
    );
  }
}

