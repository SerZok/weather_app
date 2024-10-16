part of "about_bloc.dart";

sealed class AboutEvent extends Equatable {
  const AboutEvent();
  @override
  List<Object> get props => [];
}

class AboutLoad extends AboutEvent {
  const AboutLoad({this.completer});
  final Completer? completer;
  @override
  List<Object> get props => [];
}
