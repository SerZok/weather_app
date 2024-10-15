import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:weather_app/app/app.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/repository/model/article.dart';

final GlobalKey<NavigatorState> _rootNavigationKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  observers: [TalkerRouteObserver(talker)],
  initialLocation: '/home',
  navigatorKey: _rootNavigationKey,
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
              child:ArticleScreen(article: article),
            );
          },
        ),
      ],
    ),
  ],
);
