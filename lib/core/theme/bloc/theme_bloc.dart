import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';

enum CustomThemeMode { system, light, dark, pink }

class ThemeCubit extends HydratedCubit<CustomThemeMode> {
  ThemeCubit() : super(CustomThemeMode.system);

  // Updating theme
  void updateTheme(CustomThemeMode theme) => emit(theme);

  @override
  CustomThemeMode? fromJson(Map<String, dynamic> json) {
    return CustomThemeMode.values[json['theme'] as int];
  }

  @override
  Map<String, dynamic>? toJson(CustomThemeMode state) {
    return {'theme': state.index};
  }
}
