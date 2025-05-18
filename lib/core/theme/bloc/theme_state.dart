part of 'theme_bloc.dart';

class ThemeState {
  final bool isBlueMode;

  const ThemeState({this.isBlueMode = false});

  ThemeState copyWith({bool? isBlueMode}) {
    return ThemeState(isBlueMode: isBlueMode ?? this.isBlueMode);
  }
}
