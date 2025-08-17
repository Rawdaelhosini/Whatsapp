import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark }

class ThemeState {
  final ThemeMode themeMode;
  final AppTheme currentTheme;

  ThemeState({required this.themeMode, required this.currentTheme});

  ThemeState copyWith({ThemeMode? themeMode, AppTheme? currentTheme}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeCubit()
    : super(
        ThemeState(themeMode: ThemeMode.light, currentTheme: AppTheme.light),
      ) {
    _loadTheme();
  }

  void toggleTheme() async {
    final newTheme = state.currentTheme == AppTheme.light
        ? AppTheme.dark
        : AppTheme.light;

    final newThemeMode = newTheme == AppTheme.light
        ? ThemeMode.light
        : ThemeMode.dark;

    emit(state.copyWith(themeMode: newThemeMode, currentTheme: newTheme));

    await _saveTheme(newTheme);
  }

  void setTheme(AppTheme theme) async {
    final themeMode = theme == AppTheme.light
        ? ThemeMode.light
        : ThemeMode.dark;

    emit(state.copyWith(themeMode: themeMode, currentTheme: theme));

    await _saveTheme(theme);
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;

      final theme = AppTheme.values[themeIndex];
      final themeMode = theme == AppTheme.light
          ? ThemeMode.light
          : ThemeMode.dark;

      emit(state.copyWith(themeMode: themeMode, currentTheme: theme));
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveTheme(AppTheme theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  bool get isDarkMode => state.currentTheme == AppTheme.dark;
}
