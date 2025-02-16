import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/weather_app.dart';
import 'package:weather_app/app/features/auth/bloc/auth_bloc.dart';
import 'package:weather_app/app/features/favorite/bloc/favorites_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<FavoritesBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.read<FavoritesBloc>().updateUserId(state.userId);
          }
        },
        child: const NewsBriefApp(),
      ),
    ),
  );
}
