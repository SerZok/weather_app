import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/app.dart';
import 'package:weather_app/app/extensions/widget_extensions.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/domain.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeBloc = HomeBloc(getIt<TopNewsRepository>());
  final _cityController = TextEditingController();  // Контроллер для поиска города
  final CityService _cityService = getIt<CityService>();  // Получаем сервис городов

  @override
  void initState() {
    _homeBloc.add(const HomeLoad()); // Загрузка данных при инициализации
    super.initState();
  }

  void _addCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty && !_cityService.cities.contains(city)) {
      _cityService.addCity(city);  // Добавляем новый город в список
      _homeBloc.topNewsRepository.cityService = _cityService;
      _homeBloc.add(const HomeLoad());  // Запускаем загрузку данных с новым городом
      _cityController.clear();  // Очищаем поле поиска
    }
  }

   void _deleteArticle(Article article) {
    _cityService.removeCity(article.location.name);
    _homeBloc.topNewsRepository.cityService = _cityService;
    _homeBloc.add(const HomeLoad());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Главная'),
          actions: [
            //RELOAD
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _homeBloc.add(const HomeLoad());
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
                    _buildSearchField(),  // Добавляем поле поиска
                    20.ph,
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                      return ArticleCard(
                          article: articles[index],
                          onDelete: () => _deleteArticle(articles[index]), // Передаем коллбэк для удаления
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
    );
  }

  // Поле поиска и кнопка добавления города
  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Введите город',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addCity,  // Метод для добавления города
        ),
      ],
    );
  }
}
