import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/domain/repository/model/article.dart';


class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});

  final Article article; // Параметр для хранения переданного объекта

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(article.location.name), // Отображаем название города в заголовке
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Страна: ${article.location.country}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                'Время: ${article.location.localtime}', // Время
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

