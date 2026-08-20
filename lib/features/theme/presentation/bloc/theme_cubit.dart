import 'package:bloc/bloc.dart';
import 'package:final_flutter/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.dark));

  void toggleThemeMode() {
    final ThemeMode themeMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(ThemeState(themeMode));
  }
}
