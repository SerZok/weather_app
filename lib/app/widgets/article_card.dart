import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/repository/model/article.dart';
import 'package:weather_app/domain/repository/top_news/top_news_repository.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
  });

  final Article article; // Параметр для хранения переданного объекта

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/home/article/${article.location.name}', extra: article);
      },
      borderRadius: BorderRadius.circular(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.location.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                5.ph,
                Text(
                  'Температура: ${article.current.tempC}°C', // Пример использования текущей температуры
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                10.ph,
                Text(
                  'Время: ${article.location.localtime}',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleListScreen extends StatefulWidget {
  ArticleListScreen({super.key, required this.articles});

  final List<Article> articles;
  

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
late List<Article> _articles;
  final TopNewsRepository _repository = getIt<TopNewsRepository>(); // Используем DI для получения репозитория


  Future<void> _refreshArticles() async {
    await Future.delayed(const Duration(seconds: 2)); // Пример задержки для демонстрации
    List<Article> updatedArticles = await _repository.getWeather(); // Запрашиваем обновленные данные из API

    setState(() {
      // Обновление состояния, можно обновить articles с новыми данными

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles, // Метод для обновления данных
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            return ArticleCard(
              article: widget.articles[index],
            );
          },
          separatorBuilder: (context, index) {
            return 20.ph;
          },
        ),
      ),
    );
  }
}
