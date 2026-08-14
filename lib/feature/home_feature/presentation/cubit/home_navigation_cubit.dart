import 'package:bloc/bloc.dart';

enum HomeSection { home, about, resume, skills, settings }

class HomeNavigationCubit extends Cubit<HomeSection> {
  HomeNavigationCubit([super.initialState = HomeSection.home]);

  void select(final HomeSection section) {
    emit(section);
  }
}
