import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/domain/repository/model/article.dart';
import 'package:weather_app/app/features/favorite/bloc/favorites_bloc.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.onDelete,
  });

  final Article article;
  final VoidCallback onDelete;

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
                  'Температура: ${article.current.tempC}°C',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                10.ph,
                Text('Последнее обновление: ${article.current.lastUpdated}'),
              ],
            ),
          ),
          15.ph,
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              bool isFavorite = false;
               if (state is FavoritesLoaded) {
                isFavorite = state.favorites.any((fav) => fav.location.name == article.location.name);
              }

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  if (isFavorite) {
                    context.read<FavoritesBloc>().add(RemoveFromFavorites(article.location.name));
                  } else {
                    context.read<FavoritesBloc>().add(AddToFavorites(article.location.name));
                  }
                },
              );
            },
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
