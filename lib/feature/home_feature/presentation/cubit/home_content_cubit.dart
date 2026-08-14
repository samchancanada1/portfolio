import 'package:bloc/bloc.dart';

import '../../domain/use_cases/get_home_content_use_case.dart';
import 'home_content_state.dart';

class HomeContentCubit extends Cubit<HomeContentState> {
  HomeContentCubit(this._getHomeContentUseCase)
      : super(const HomeContentState.initial()) {
    load();
  }

  final GetHomeContentUseCase _getHomeContentUseCase;

  void load() {
    emit(
      state.copyWith(
        status: HomeContentStatus.loaded,
        content: _getHomeContentUseCase(),
      ),
    );
  }
}
