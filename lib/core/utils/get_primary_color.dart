import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../feature/home_feature/presentation/bloc/primary_color_cubit.dart';
import '../utils/check_theme_status.dart';

Color getPrimaryColor(final BuildContext context) {
  return checkDarkMode(context)
      ? context.watch<PrimaryColorCubit>().state.lightPrimaryColor
      : context.watch<PrimaryColorCubit>().state.primaryColor;
}
