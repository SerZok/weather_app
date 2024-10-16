import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/di/di.dart';
import 'package:weather_app/domain/domain.dart';

part "about_event.dart";
part "about_state.dart";

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final TopNewsRepository topNewsRepository;
  AboutBloc(this.topNewsRepository) : super(AboutInitial()) {
    on<AboutLoad>(_AboutLoad);
  }
  Future<void> _AboutLoad(event, emit) async {
    try {
      if (state is! AboutLoadSuccess) {
        emit(AboutLoadInProgress());
      }
      final articles = await topNewsRepository.getWeather();
      emit(AboutLoadSuccess(
        articles: articles,
      ));
    } catch (exception, state) {
      emit(AboutLoadFailure(exception: exception));
      talker.handle(exception, state);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
