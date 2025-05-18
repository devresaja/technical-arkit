part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class UpdateThemeEvent extends ThemeEvent {
  final bool isBlueMode;

  UpdateThemeEvent({this.isBlueMode = true});
}
