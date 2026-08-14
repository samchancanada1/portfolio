import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/feature/home_feature/data/repositories/static_portfolio_repository.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/get_home_content_use_case.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_content_cubit.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_content_state.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_navigation_cubit.dart';

void main() {
  test('get home content use case exposes portfolio content', () {
    const repository = StaticPortfolioRepository();
    const useCase = GetHomeContentUseCase(repository);

    final content = useCase();

    expect(content.experiences.map((final item) => item.company),
        contains('BoursePad'));
    expect(content.capabilityGroups.map((final item) => item.title),
        contains('Architecture'));
    expect(content.contactActions.map((final item) => item.label),
        contains('LinkedIn'));
  });

  test('home content cubit loads content on creation', () {
    const repository = StaticPortfolioRepository();
    const useCase = GetHomeContentUseCase(repository);

    final cubit = HomeContentCubit(useCase);

    expect(cubit.state.status, HomeContentStatus.loaded);
    expect(cubit.state.content?.allSkills, contains('Clean Architecture'));

    cubit.close();
  });

  test('home navigation cubit selects sections', () {
    final cubit = HomeNavigationCubit();

    cubit.select(HomeSection.resume);

    expect(cubit.state, HomeSection.resume);

    cubit.close();
  });
}
