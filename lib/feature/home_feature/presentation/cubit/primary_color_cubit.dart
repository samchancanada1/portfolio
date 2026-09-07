import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
part 'primary_color_state.dart';

class PrimaryColorCubit extends Cubit<PrimaryColorState> {
  PrimaryColorCubit()
      : super(
          PrimaryColorState(
            primaryColor: AppColors.primaryColor,
            lightPrimaryColor: AppColors.lightPrimaryColor,
          ),
        );

  void setRedColor() {
    emit(
      state.copyWith(
        primaryColor: Colors.red,
        lightPrimaryColor: Colors.red,
      ),
    );
  }

  void setOrangeColor() {
    emit(
      state.copyWith(
        primaryColor: AppColors.orange,
        lightPrimaryColor: AppColors.orange,
      ),
    );
  }

  void setBlueColor() {
    emit(
      state.copyWith(
        primaryColor: Colors.blue,
        lightPrimaryColor: Colors.blue,
      ),
    );
  }

  void setPurpleColor() {
    emit(
      state.copyWith(
        primaryColor: AppColors.primaryColor,
        lightPrimaryColor: AppColors.lightPrimaryColor,
      ),
    );
  }
}
