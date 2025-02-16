import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Импортируем для проверки состояния пользователя

import 'package:weather_app/app/app.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/repository/model/article.dart';
import 'package:weather_app/app/features/favorite/favorite_screen.dart';

// GlobalKey для навигации
final GlobalKey<NavigatorState> _rootNavigationKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

// Определяем GoRouter
final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  observers: [TalkerRouteObserver(talker)],
  navigatorKey: _rootNavigationKey,

  // Добавляем логику редиректа в зависимости от состояния авторизации
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Если пользователь не авторизован, перенаправляем на /home
  if (user == null && state.uri.path != '/home' && !state.uri.path.startsWith('/home/article')) {
    return '/home'; 
  }
    // Если пользователь авторизован, перенаправляем на /favorites
    return null; // null означает, что редиректа не нужно
  },
  
  initialLocation: '/home', // начальный маршрут

  // Обработчики маршрутов
  routes: <RouteBase>[
    
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
        );
      },

      routes: [
        GoRoute(
          path: 'article/:id',
          pageBuilder: (context, state) {
            final Article article = state.extra as Article;

            return NoTransitionPage<void>(
              key: state.pageKey,
              child: ArticleScreen(article: article),
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/favorites',
      pageBuilder: (context, state) {
        return NoTransitionPage<void>(
          key: state.pageKey,
          child: FavoriteScreen(),
        );
      },
    ),
  ],
);
