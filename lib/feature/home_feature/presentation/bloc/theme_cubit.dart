import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/data_sources/local/home_storage.dart';

class ThemeCubit extends Cubit<ThemeMode?> {
  ThemeCubit() : super(null) {
    initTheme();
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      HomeStorage().setTheme('dark');
    } else {
      HomeStorage().setTheme('light');
    }
    emit(
      state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> initTheme() async {
    final String storedTheme = await HomeStorage().getTheme() ?? '';
    if (storedTheme == '') {
      emit(
        ThemeMode.dark,
      );
    }
    if (storedTheme == 'light') {
      emit(
        ThemeMode.light,
      );
    } else {
      emit(
        ThemeMode.dark,
      );
    }
  }
}
