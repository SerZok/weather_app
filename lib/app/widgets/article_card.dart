import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/domain/repository/model/article.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.onDelete,
  });

  final Article article; // Параметр для хранения переданного объекта
  final VoidCallback onDelete; // Коллбэк для удаления статьи

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
                  'Последнее обновление: ${article.current.lastUpdated}',
                )
              ],
            ),
          ),
          15.ph,
          IconButton(
            onPressed: onDelete, 
            icon: Icon(Icons.delete),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}