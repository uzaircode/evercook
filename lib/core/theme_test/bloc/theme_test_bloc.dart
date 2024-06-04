import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_test_event.dart';

class ThemeTestBloc extends Bloc<ThemeTestEvent, ThemeMode> {
  ThemeTestBloc() : super(ThemeMode.light) {
    on<ThemeChanged>((event, emit) {
      emit(event.isDark ? ThemeMode.dark : ThemeMode.light);
    });
  }
}
