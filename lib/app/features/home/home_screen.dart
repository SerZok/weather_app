import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/app/features/auth/bloc/bloc.dart';
import 'package:weather_app/app/features/auth/auth_screen.dart';
import 'package:weather_app/app/features/favorite/favorite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = HomeBloc(getIt<TopNewsRepository>());
  final _cityController = TextEditingController();  
  final CityService _cityService = getIt<CityService>();  

  @override
  void initState() {
    super.initState();
    _homeBloc.add(const HomeLoad());

    // Подписываемся на изменения избранных городов
  context.read<FavoritesBloc>().stream.listen((state) {
    if (state is FavoritesLoaded) {
      _homeBloc.add(const HomeLoad()); // Перезагружаем данные
    }
  });
  }

  void _addCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty && !_cityService.cities.contains(city)) {
      _cityService.addCity(city);
      _homeBloc.topNewsRepository.cityService = _cityService;
      _homeBloc.add(const HomeLoad());
      _cityController.clear();
    }
  }

  void _deleteArticle(Article article) {
    _cityService.removeCity(article.location.name);
    _homeBloc.topNewsRepository.cityService = _cityService;
    _homeBloc.add(const HomeLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Перенаправляем на экран входа
          context.go('/home');
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Главная'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _homeBloc.add(const HomeLoad());
                },
              ),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogOut());
                      },
                    );

                    
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AuthScreen()),
                        );
                      },
                    );
                  }
                },
              ),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        context.go("/favorites");
                      },
                    );
                  }
                  return SizedBox.shrink();// Если пользователь не авторизован, кнопка скрыта
                },
              ),

            ],
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            bloc: _homeBloc,
            builder: (context, state) {
              if (state is HomeLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeLoadSuccess) {
                List<Article> articles = state.articles;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Погода',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      20.ph,
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                labelText: 'Введите город',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addCity, 
                          ),
                        ],
                      ),

                      20.ph,
                      ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return ArticleCard(
                            article: articles[index],
                            onDelete: () => _deleteArticle(articles[index]),
                          );
                        },
                        separatorBuilder: (context, index) => 20.ph,
                      ),
                    ],
                  ),
                );
              }
              if (state is HomeLoadFailure) {
                return ErrorCard(
                  title: 'Ошибка',
                  description: state.exception.toString(),
                  onReload: () {
                    _homeBloc.add(const HomeLoad());
                  },
                );
              }
              return const SizedBox();
            },
          ),
        
        ),
      ),
    );
  }
}
