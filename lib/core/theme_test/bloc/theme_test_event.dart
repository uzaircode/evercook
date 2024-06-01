part of 'theme_test_bloc.dart';

@immutable
sealed class ThemeTestEvent {}

class ThemeChanged extends ThemeTestEvent {
  final bool isDark;

  ThemeChanged(this.isDark);
}
