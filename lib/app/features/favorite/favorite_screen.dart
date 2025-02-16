import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/app/features/favorite/bloc/favorites_bloc.dart';
import 'package:weather_app/domain/repository/model/article.dart';
import 'package:weather_app/app/widgets/article_card.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              context.go("/home");
          },
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final article = state.favorites[index];
                return ArticleCard(
                  article: article,
                  onDelete: () {
                    context.read<FavoritesBloc>().add(RemoveFromFavorites(article.location.name));
                  },
                );
              },
              separatorBuilder: (context, index) => 20.ph
            );
          } else if (state is FavoritesError) {
            return Center(child: Text("Ошибка: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}