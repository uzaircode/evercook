part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final bool isDark;

  ThemeChanged(this.isDark);
}
