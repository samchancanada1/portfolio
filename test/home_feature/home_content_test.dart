import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/feature/home_feature/data/repositories/static_portfolio_repository.dart';
import 'package:portfolio/feature/home_feature/domain/entities/home_icon_key.dart';
import 'package:portfolio/feature/home_feature/domain/entities/portfolio_content.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/get_home_content_use_case.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_content_cubit.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_content_state.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/home_navigation_cubit.dart';

void main() {
  test('static repository exposes complete portfolio sections', () {
    const repository = StaticPortfolioRepository();

    expect(repository.getHeroProfile().role, 'Flutter Mobile Developer');
    expect(repository.getHeroProfile().metrics, hasLength(2));
    expect(repository.getAboutProfile().info.map((final item) => item.label),
        contains('Email'));
    expect(repository.getCoreCompetencies().impacts, hasLength(4));
    expect(repository.getSkillsOverview().toolboxTitle, 'Detailed toolbox');
    expect(repository.getDesignLenses(), hasLength(4));
    expect(repository.getStats(), hasLength(4));
    expect(repository.getExperiences().length, greaterThan(3));
    expect(repository.getCapabilityGroups().length, greaterThan(4));
    expect(repository.getAllSkills(), contains('Flutter (Android, iOS, Web)'));
    expect(repository.getContactActions().last.icon, HomeIconKey.mail);
  });

  test('get home content use case exposes portfolio content', () {
    const repository = StaticPortfolioRepository();
    const useCase = GetHomeContentUseCase(repository);

    final content = useCase();

    expect(content.experiences.map((final item) => item.company),
        contains('BoursePad'));
    expect(content.hero.stack.chips, contains('Firebase'));
    expect(content.about.info.map((final item) => item.value),
        contains('samchancanada1@gmail.com'));
    expect(content.coreCompetencies.badges, contains('Offline-first'));
    expect(content.skillsOverview.description, contains('mobile development'));
    expect(content.designLenses.map((final item) => item.icon),
        contains(HomeIconKey.devices));
    expect(content.stats.map((final item) => item.value), contains('6+'));
    expect(content.capabilityGroups.map((final item) => item.title),
        contains('Architecture'));
    expect(content.contactActions.map((final item) => item.label),
        contains('LinkedIn'));
  });

  test('home content state copies values and compares by props', () {
    const repository = StaticPortfolioRepository();
    const useCase = GetHomeContentUseCase(repository);
    final content = useCase();

    const initial = HomeContentState.initial();
    final loaded = initial.copyWith(
      status: HomeContentStatus.loaded,
      content: content,
    );
    final statusOnly = loaded.copyWith(status: HomeContentStatus.initial);
    final sameLoaded = HomeContentState(
      status: HomeContentStatus.loaded,
      content: content,
    );

    expect(initial.status, HomeContentStatus.initial);
    expect(initial.content, isNull);
    expect(loaded.status, HomeContentStatus.loaded);
    expect(loaded.content, content);
    expect(statusOnly.status, HomeContentStatus.initial);
    expect(statusOnly.content, content);
    expect(loaded, sameLoaded);
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

    for (final section in HomeSection.values) {
      cubit.select(section);

      expect(cubit.state, section);
    }

    cubit.close();
  });

  test('portfolio content value objects expose constructor data', () {
    const link = ResumeLink('Store', 'https://example.com');
    const stat = PortfolioStat('1', 'Release', HomeIconKey.rocketLaunch);
    const contact = ContactAction(
      'Email',
      HomeIconKey.mail,
      'mailto:test@example.com',
    );
    const lens = DesignLens('UX', 'Clear flow', HomeIconKey.route);
    const group = CapabilityGroup(
      title: 'Architecture',
      description: 'Layered app structure',
      icon: HomeIconKey.accountTree,
      skills: ['BLoC'],
    );
    const experience = Experience(
      company: 'Company',
      role: 'Developer',
      location: 'Remote',
      period: '2026',
      points: ['Built feature'],
      tech: ['Flutter'],
      links: [link],
    );

    expect(link.label, 'Store');
    expect(stat.icon, HomeIconKey.rocketLaunch);
    expect(contact.logoPath, isNull);
    expect(lens.description, 'Clear flow');
    expect(group.skills.single, 'BLoC');
    expect(experience.links.single.url, 'https://example.com');
  });
}
