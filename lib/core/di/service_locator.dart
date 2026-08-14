import 'package:get_it/get_it.dart';

import '../../feature/home_feature/data/repositories/static_portfolio_repository.dart';
import '../../feature/home_feature/domain/repositories/portfolio_repository.dart';
import '../../feature/home_feature/domain/use_cases/get_home_content_use_case.dart';
import '../../feature/home_feature/presentation/cubit/home_content_cubit.dart';
import '../../feature/home_feature/presentation/cubit/home_navigation_cubit.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  if (locator.isRegistered<PortfolioRepository>()) {
    return;
  }

  locator.registerLazySingleton<PortfolioRepository>(
    () => const StaticPortfolioRepository(),
  );
  locator.registerLazySingleton<GetHomeContentUseCase>(
    () => GetHomeContentUseCase(locator<PortfolioRepository>()),
  );
  locator.registerFactory<HomeContentCubit>(
    () => HomeContentCubit(locator<GetHomeContentUseCase>()),
  );
  locator.registerFactory<HomeNavigationCubit>(HomeNavigationCubit.new);
}
