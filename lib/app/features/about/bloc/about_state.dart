part of "about_bloc.dart";

sealed class AboutState extends Equatable {
  const AboutState();
  @override
  List<Object> get props => [];
}

final class AboutInitial extends AboutState {}

final class AboutLoadInProgress extends AboutState {}

final class AboutLoadSuccess extends AboutState {
  const AboutLoadSuccess({
    required this.articles,
  });
  final List<Article> articles;
  @override
  List<Object> get props => [articles];
}

final class AboutLoadFailure extends AboutState {
  const AboutLoadFailure({
    required this.exception,
  });
  final Object? exception;
  @override
  List<Object> get props => [];
}
