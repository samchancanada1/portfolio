import 'dart:math' as math;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/routes/go_routes_path.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_theme_status.dart';
import '../../../../core/utils/locale_handler.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/entities/home_icon_key.dart';
import '../../domain/entities/portfolio_content.dart';
import '../cubit/home_content_cubit.dart';
import '../cubit/home_content_state.dart';
import '../cubit/home_navigation_cubit.dart';
import '../cubit/primary_color_cubit.dart';
import '../cubit/theme_cubit.dart';
import '../mappers/home_icon_mapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.initialSection = HomeSection.home,
  });

  final HomeSection initialSection;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => locator<HomeNavigationCubit>(param1: initialSection),
        ),
        BlocProvider(create: (_) => locator<HomeContentCubit>()),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  List<_NavItem> get _items => [
        _NavItem(
          t.home_screen.home,
          Icons.grid_view_rounded,
          HomeSection.home,
        ),
        _NavItem(
          t.home_screen.about,
          Icons.person_pin_rounded,
          HomeSection.about,
        ),
        _NavItem(
          t.home_screen.resume,
          Icons.work_history_rounded,
          HomeSection.resume,
        ),
        _NavItem(
          t.home_screen.skills,
          Icons.auto_awesome_motion_rounded,
          HomeSection.skills,
        ),
        _NavItem(
          t.home_screen.settings,
          Icons.tune_rounded,
          HomeSection.settings,
        ),
      ];

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 960;
    final List<_NavItem> items = _items;

    return BlocBuilder<HomeNavigationCubit, HomeSection>(
      builder: (final context, final selectedSection) {
        final int selectedIndex = selectedSection.index;
        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.ink,
          body: _PortfolioBackground(
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PageTransitionSwitcher(
                      transitionBuilder: (
                        final Widget child,
                        final Animation<double> animation,
                        final Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.scaled,
                          child: child,
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<HomeSection>(selectedSection),
                        child: _sectionFor(selectedSection),
                      ),
                    ),
                  ),
                  if (isWide)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: _SideNavigation(
                        items: items,
                        selectedIndex: selectedIndex,
                        onSelected: (final index) => _openSection(
                          context,
                          items[index].section,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isWide
              ? null
              : _BottomNavigation(
                  items: items,
                  selectedIndex: selectedIndex,
                  onSelected: (final index) => _openSection(
                    context,
                    items[index].section,
                  ),
                ),
        );
      },
    );
  }

  void _openSection(
    final BuildContext context,
    final HomeSection section,
  ) {
    context.read<HomeNavigationCubit>().select(section);
    final String routePath = _routePathFor(section);
    if (GoRouterState.of(context).uri.path != routePath) {
      context.go(routePath);
    }
  }

  String _routePathFor(final HomeSection section) {
    switch (section) {
      case HomeSection.home:
        return GoRoutesPath.home;
      case HomeSection.about:
        return GoRoutesPath.about;
      case HomeSection.resume:
        return GoRoutesPath.resume;
      case HomeSection.skills:
        return GoRoutesPath.skills;
      case HomeSection.settings:
        return GoRoutesPath.settings;
    }
  }

  Widget _sectionFor(final HomeSection section) {
    switch (section) {
      case HomeSection.home:
        return const _HomeView();
      case HomeSection.about:
        return const _AboutView();
      case HomeSection.resume:
        return const _ResumeView();
      case HomeSection.skills:
        return const _SkillsView();
      case HomeSection.settings:
        return const _SettingsView();
    }
  }
}

class _PortfolioBackground extends StatelessWidget {
  const _PortfolioBackground({required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final bool dark = checkDarkMode(context);

    return CustomPaint(
      foregroundPainter: _StudioGridPainter(
        lineColor: (dark ? AppColors.ivory : AppColors.ink).withValues(
          alpha: dark ? 0.035 : 0.04,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.ink,
          image: DecorationImage(
            image: AssetImage(Assets.images.homeBackground.path),
            fit: BoxFit.cover,
            opacity: dark ? 0.12 : 0.06,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? const [
                      Color(0xff020405),
                      Color(0xff070A0B),
                      Color(0xff0E1511),
                    ]
                  : const [
                      Color(0xffF3F5F1),
                      Color(0xffE8EFEA),
                      Color(0xffF6F7F2),
                    ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StudioGridPainter extends CustomPainter {
  const _StudioGridPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 96) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 96) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(final _StudioGridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}

class _SideNavigation extends StatefulWidget {
  const _SideNavigation({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<_SideNavigation> {
  bool _expanded = false;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const Duration duration = Duration(milliseconds: 220);

    return MouseRegion(
      onEnter: (_) => setState(() => _expanded = true),
      onExit: (_) => setState(() => _expanded = false),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        width: _expanded ? 292 : 84,
        margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        padding: EdgeInsets.symmetric(
          horizontal: _expanded ? Dimens.largePadding : 12,
          vertical: Dimens.largePadding,
        ),
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: _expanded ? 0.86 : 0.68),
          borderRadius: BorderRadius.circular(Dimens.corners),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _expanded ? 0.22 : 0.12),
              blurRadius: _expanded ? 34 : 18,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              _expanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: _expanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: t.home_screen.myName,
                  child: CircleAvatar(
                    radius: _expanded ? 27 : 24,
                    backgroundImage:
                        AssetImage(Assets.images.profileImage.path),
                  ),
                ),
                AnimatedSwitcher(
                  duration: duration,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _expanded
                      ? Padding(
                          key: const ValueKey<String>('identity-expanded'),
                          padding: const EdgeInsets.only(
                            left: Dimens.mediumPadding,
                          ),
                          child: SizedBox(
                            width: 176,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.home_screen.myName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  _homeContent(context).hero.role,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey<String>('identity-collapsed'),
                        ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.extraLargePadding),
            ...List.generate(widget.items.length, (final int index) {
              return _NavButton(
                item: widget.items[index],
                selected: widget.selectedIndex == index,
                compact: !_expanded,
                onTap: () => widget.onSelected(index),
              );
            }),
            const Spacer(),
            AnimatedSwitcher(
              duration: duration,
              child: _expanded
                  ? const _ContactStrip(
                      key: ValueKey<String>('contact-expanded'),
                      compact: true,
                    )
                  : IconButton.filledTonal(
                      key: const ValueKey<String>('contact-collapsed'),
                      style: IconButton.styleFrom(
                        backgroundColor: scheme.primary.withValues(alpha: 0.16),
                        foregroundColor: scheme.primary,
                      ),
                      tooltip: 'Email',
                      onPressed: _launchMail,
                      icon: const Icon(Icons.mail_rounded),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color foreground =
        selected ? scheme.primary : scheme.onSurfaceVariant;
    final Widget icon = Icon(item.icon, color: foreground, size: 21);

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.padding),
      child: Tooltip(
        message: item.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimens.corners),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            height: 48,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 0 : Dimens.largePadding,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: compact ? 0.2 : 0.16)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(Dimens.corners),
              border: Border.all(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.34)
                    : Colors.transparent,
              ),
            ),
            child: Center(
              child: compact
                  ? icon
                  : Row(
                      children: [
                        icon,
                        const SizedBox(width: Dimens.mediumPadding),
                        Expanded(
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  selected ? scheme.primary : scheme.onSurface,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.corners),
        child: NavigationBar(
          backgroundColor: scheme.surface.withValues(alpha: 0.95),
          indicatorColor: scheme.primary.withValues(alpha: 0.16),
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          destinations: [
            for (final _NavItem item in items)
              NavigationDestination(icon: Icon(item.icon), label: item.label),
          ],
        ),
      ),
    );
  }
}

class _SectionScaffold extends StatelessWidget {
  const _SectionScaffold({
    required this.eyebrow,
    required this.title,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final Size viewport = MediaQuery.sizeOf(context);
    final bool compact = viewport.width < 720 || viewport.height < 760;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            _contentInset(context, leading: true),
            Dimens.extraLargePadding,
            _contentInset(context),
            96,
          ),
          sliver: SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Eyebrow(eyebrow),
                  const SizedBox(height: Dimens.padding),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: compact ? 34 : null,
                          fontWeight: FontWeight.w900,
                          height: 1.04,
                        ),
                  ),
                  const SizedBox(height: Dimens.extraLargePadding),
                  child,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _workKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final HeroProfile hero = _homeContent(context).hero;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              _contentInset(context, leading: true),
              Dimens.largePadding,
              _contentInset(context),
              96,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroStage(
                      hero: hero,
                      onViewProjects: _jumpToWork,
                      onStartConversation: _jumpToContact,
                    ),
                    const SizedBox(height: Dimens.extraLargePadding),
                    KeyedSubtree(
                      key: _workKey,
                      child: const _FeaturedWorkShowcase(),
                    ),
                    const SizedBox(height: Dimens.extraLargePadding),
                    const _ScrollReveal(
                      delay: Duration(milliseconds: 120),
                      child: _MoreTechnicalWorkStrip(),
                    ),
                    const SizedBox(height: Dimens.extraLargePadding),
                    const _ScrollReveal(
                      delay: Duration(milliseconds: 160),
                      child: _DesignLensStrip(),
                    ),
                    const SizedBox(height: Dimens.extraLargePadding),
                    _ScrollReveal(
                      delay: const Duration(milliseconds: 180),
                      child: KeyedSubtree(
                        key: _contactKey,
                        child: _ContactStrip(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _jumpToWork() {
    final BuildContext? targetContext = _workKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        alignment: 0.02,
      );
      return;
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent * 0.36,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _jumpToContact() {
    final BuildContext? targetContext = _contactKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
      return;
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _HeroStage extends StatelessWidget {
  const _HeroStage({
    required this.hero,
    required this.onViewProjects,
    required this.onStartConversation,
  });

  final HeroProfile hero;
  final VoidCallback onViewProjects;
  final VoidCallback onStartConversation;

  @override
  Widget build(final BuildContext context) {
    final bool dark = checkDarkMode(context);
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final bool isWide = constraints.maxWidth >= 920;
        final Size viewport = MediaQuery.sizeOf(context);
        final double stageHeight = isWide
            ? math.max(590, math.min(660, viewport.height - 150))
            : math.max(650, math.min(760, viewport.height - 96));
        final double productWallBleed = isWide
            ? math.max(44, math.min(140, constraints.maxWidth * 0.08))
            : 170;

        return SizedBox(
          height: stageHeight,
          child: Container(
            width: double.infinity,
            height: stageHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: dark ? const Color(0xff030607) : const Color(0xffF7F9F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (dark ? AppColors.ivory : AppColors.ink).withValues(
                  alpha: dark ? 0.1 : 0.08,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.34 : 0.12),
                  blurRadius: 42,
                  offset: const Offset(0, 22),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/hero-premium-background.png',
                    fit: BoxFit.cover,
                    opacity: dark
                        ? const AlwaysStoppedAnimation<double>(0.68)
                        : const AlwaysStoppedAnimation<double>(0.42),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: dark ? 0.52 : 0.22),
                          Colors.black.withValues(alpha: dark ? 0.18 : 0.06),
                          Colors.black.withValues(alpha: dark ? 0.78 : 0.3),
                        ],
                        stops: const [0, 0.48, 1],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HeroRunwayPainter(
                      color: scheme.primary,
                      dark: dark,
                    ),
                  ),
                ),
                Positioned(
                  left: -productWallBleed,
                  right: -productWallBleed,
                  top: isWide ? 98 : 138,
                  bottom: isWide ? 18 : 74,
                  child: IgnorePointer(
                    child: _HeroProductWall(stageWidth: constraints.maxWidth),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, 0.18),
                        radius: 1.08,
                        colors: [
                          Colors.transparent,
                          (dark ? Colors.black : Colors.white).withValues(
                            alpha: dark ? 0.14 : 0.04,
                          ),
                          (dark ? Colors.black : Colors.white).withValues(
                            alpha: dark ? 0.66 : 0.34,
                          ),
                        ],
                        stops: const [0, 0.56, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: isWide ? 52 : 22,
                  right: isWide ? 52 : 22,
                  top: isWide ? 36 : 24,
                  child: _HeroScanLine(
                    color: scheme.primary.withValues(alpha: dark ? 0.32 : 0.2),
                  ),
                ),
                Positioned(
                  left: isWide ? 52 : 22,
                  right: isWide ? 52 : 22,
                  bottom: isWide ? 34 : 24,
                  child: _HeroScanLine(
                    color: Colors.white.withValues(alpha: dark ? 0.18 : 0.26),
                  ),
                ),
                Positioned(
                  left: isWide ? 36 : 20,
                  top: isWide ? 30 : 20,
                  child: _StageBeam(
                    width: isWide ? 250 : 164,
                    height: isWide ? 82 : 58,
                    color: scheme.primary.withValues(alpha: dark ? 0.12 : 0.08),
                  ),
                ),
                Positioned(
                  right: isWide ? 22 : -30,
                  bottom: isWide ? -46 : 28,
                  child: Text(
                    'FLUTTER',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: (dark ? Colors.white : AppColors.ink)
                              .withValues(alpha: dark ? 0.045 : 0.032),
                          fontSize: isWide ? 144 : 70,
                          fontWeight: FontWeight.w900,
                          height: 0.9,
                        ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: isWide ? 330 : 350,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: dark ? 0.42 : 0.28),
                          Colors.black.withValues(alpha: dark ? 0.46 : 0.24),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: isWide ? 72 : 26,
                  right: isWide ? 72 : 26,
                  top: isWide ? 56 : 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 90,
                          spreadRadius: 34,
                        ),
                      ],
                    ),
                    child: _HeroVisualCopy(
                      hero: hero,
                      onViewProjects: onViewProjects,
                      onStartConversation: onStartConversation,
                      compact: !isWide,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroVisualCopy extends StatelessWidget {
  const _HeroVisualCopy({
    required this.hero,
    required this.onViewProjects,
    required this.onStartConversation,
    required this.compact,
  });

  final HeroProfile hero;
  final VoidCallback onViewProjects;
  final VoidCallback onStartConversation;
  final bool compact;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Reveal(
          delay: const Duration(milliseconds: 80),
          beginOffset: const Offset(0, 0.36),
          child: _Eyebrow(hero.eyebrow),
        ),
        SizedBox(height: compact ? Dimens.mediumPadding : Dimens.largePadding),
        _Reveal(
          delay: const Duration(milliseconds: 150),
          beginOffset: const Offset(0, 0.14),
          child: Text(
            t.home_screen.myName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: compact ? 46 : 68,
              fontWeight: FontWeight.w900,
              height: 0.9,
              letterSpacing: 0,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.92),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
                Shadow(
                  color: Colors.black.withValues(alpha: 0.52),
                  blurRadius: 58,
                  offset: const Offset(0, 22),
                ),
                Shadow(
                  color: scheme.primary.withValues(alpha: 0.2),
                  blurRadius: 54,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimens.smallPadding),
        _Reveal(
          delay: const Duration(milliseconds: 220),
          beginOffset: const Offset(0, 0.12),
          child: Text(
            'Senior Flutter products, shipped.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: compact ? 29 : 45,
              fontWeight: FontWeight.w900,
              height: 0.98,
              letterSpacing: 0,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.98),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
                Shadow(
                  color: Colors.black.withValues(alpha: 0.62),
                  blurRadius: 44,
                  offset: const Offset(0, 18),
                ),
                Shadow(
                  color: scheme.primary.withValues(alpha: 0.16),
                  blurRadius: 46,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
            height: compact ? Dimens.largePadding : Dimens.extraLargePadding),
        _Reveal(
          delay: const Duration(milliseconds: 310),
          beginOffset: const Offset(0, 0.16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: Dimens.mediumPadding,
            runSpacing: Dimens.mediumPadding,
            children: [
              FilledButton.icon(
                onPressed: onViewProjects,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(hero.primaryActionLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: const Color(0xff06110B),
                  elevation: 0,
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onStartConversation,
                icon: const Icon(Icons.mail_rounded),
                label: Text(hero.secondaryActionLabel),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.42),
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.62),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroProductWall extends StatefulWidget {
  const _HeroProductWall({required this.stageWidth});

  final double stageWidth;

  @override
  State<_HeroProductWall> createState() => _HeroProductWallState();
}

class _HeroProductWallState extends State<_HeroProductWall>
    with SingleTickerProviderStateMixin {
  static const List<String> _screens = [
    'assets/images/boursepad-mockup.png',
    'assets/images/construction-workforce-dashboard-mockup.png',
    'assets/images/construction-documents-mockup.png',
    'assets/images/coach-products-mockup.png',
    'assets/images/coach-payment-mockup.png',
    'assets/images/boursepad-detail-mockup.png',
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final double visibleWidth =
            widget.stageWidth.clamp(360.0, 1280.0).toDouble();
        final double fanProgress =
            ((visibleWidth - 360) / 920).clamp(0.0, 1.0).toDouble();
        final double t = Curves.easeInOutCubic.transform(fanProgress);
        final double heightLimitedWidth = constraints.maxHeight * 0.94 * 9 / 16;
        final double centerWidth =
            math.min(_lerpDouble(188, 304, t), heightLimitedWidth);
        final double sideWidth = centerWidth * _lerpDouble(0.82, 0.86, t);
        final double farWidth = centerWidth * _lerpDouble(0.66, 0.72, t);
        final double sideOffset = centerWidth * _lerpDouble(0.54, 0.78, t);
        final double farOffset = centerWidth * _lerpDouble(0.98, 1.48, t);
        final double baseBottom = _lerpDouble(0, 4, t);
        final List<_HeroWallTileSpec> specs = [
          _HeroWallTileSpec(
            path: _screens[3],
            centerOffset: -farOffset,
            bottom: baseBottom + _lerpDouble(6, 0, t),
            width: farWidth,
            angle: -_lerpDouble(0.22, 0.34, t),
            opacity: _lerpDouble(0.48, 0.58, t),
            phase: 0.1,
          ),
          _HeroWallTileSpec(
            path: _screens[4],
            centerOffset: farOffset,
            bottom: baseBottom,
            width: farWidth,
            angle: _lerpDouble(0.22, 0.34, t),
            opacity: _lerpDouble(0.5, 0.6, t),
            phase: 0.96,
          ),
          _HeroWallTileSpec(
            path: _screens[1],
            centerOffset: -sideOffset,
            bottom: baseBottom + _lerpDouble(12, 8, t),
            width: sideWidth,
            angle: -_lerpDouble(0.1, 0.18, t),
            opacity: _lerpDouble(0.76, 0.84, t),
            phase: 0.32,
          ),
          _HeroWallTileSpec(
            path: _screens[2],
            centerOffset: sideOffset,
            bottom: baseBottom + _lerpDouble(10, 8, t),
            width: sideWidth,
            angle: _lerpDouble(0.13, 0.18, t),
            opacity: _lerpDouble(0.78, 0.86, t),
            phase: 0.78,
          ),
          _HeroWallTileSpec(
            path: _screens[0],
            centerOffset: 0,
            bottom: baseBottom + _lerpDouble(20, 12, t),
            width: centerWidth,
            angle: 0,
            opacity: 1,
            phase: 0.56,
          ),
        ];

        return AnimatedBuilder(
          animation: _controller,
          builder: (final context, final child) {
            final double progress = _controller.value;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HeroProductWallPainter(progress: progress),
                  ),
                ),
                for (int index = 0; index < specs.length; index++)
                  _HeroWallTile(
                    spec: specs[index],
                    progress: progress,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

double _lerpDouble(
  final double begin,
  final double end,
  final double progress,
) {
  return begin + (end - begin) * progress;
}

class _HeroWallTileSpec {
  const _HeroWallTileSpec({
    required this.path,
    required this.centerOffset,
    required this.bottom,
    required this.width,
    required this.angle,
    required this.opacity,
    required this.phase,
  });

  final String path;
  final double centerOffset;
  final double bottom;
  final double width;
  final double angle;
  final double opacity;
  final double phase;
}

class _HeroWallTile extends StatelessWidget {
  const _HeroWallTile({
    required this.spec,
    required this.progress,
  });

  final _HeroWallTileSpec spec;
  final double progress;

  @override
  Widget build(final BuildContext context) {
    final double cycle = (progress + spec.phase) * math.pi * 2;
    final double driftX = math.sin(cycle) * 5;
    final double driftY = math.cos(cycle) * 6;
    final double driftAngle = math.sin(cycle) * 0.008;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final double width = spec.width;
          final double centerX =
              (constraints.maxWidth / 2) + spec.centerOffset + driftX;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: centerX - (width / 2),
                bottom: spec.bottom + driftY,
                width: width,
                child: Transform.rotate(
                  alignment: Alignment.bottomCenter,
                  angle: spec.angle + driftAngle,
                  child: Opacity(
                    opacity: spec.opacity,
                    child: Container(
                      padding: EdgeInsets.all(width * 0.018),
                      decoration: BoxDecoration(
                        color: const Color(0xff070A0B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primaryColor.withValues(alpha: 0.1),
                            blurRadius: 52,
                            offset: const Offset(0, 22),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.54),
                            blurRadius: 46,
                            offset: const Offset(0, 28),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                spec.path,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.08),
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.34),
                                    ],
                                    stops: const [0, 0.42, 1],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroProductWallPainter extends CustomPainter {
  const _HeroProductWallPainter({required this.progress});

  final double progress;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.62);
    final Paint railPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.08);
    final Paint accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryColor.withValues(alpha: 0.28);

    for (int index = -3; index <= 3; index++) {
      final double x = center.dx + (index * size.width * 0.12);
      canvas.drawLine(
        Offset(x, size.height * 0.16),
        Offset(center.dx + index * 18, size.height * 0.96),
        railPaint,
      );
    }

    final Path sweep = Path()
      ..moveTo(size.width * -0.06, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * (0.58 + math.sin(progress * math.pi * 2) * 0.02),
        size.width * 1.06,
        size.height * 0.82,
      );
    canvas.drawPath(sweep, accentPaint);
  }

  @override
  bool shouldRepaint(final _HeroProductWallPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _HeroRunwayPainter extends CustomPainter {
  const _HeroRunwayPainter({
    required this.color,
    required this.dark,
  });

  final Color color;
  final bool dark;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = (dark ? Colors.white : AppColors.ink).withValues(
        alpha: dark ? 0.06 : 0.045,
      );
    final Paint accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: dark ? 0.18 : 0.14);

    const double step = 118;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Path diagonal = Path()
      ..moveTo(size.width * 0.08, size.height * 0.78)
      ..lineTo(size.width * 0.5, size.height * 0.56)
      ..lineTo(size.width * 0.92, size.height * 0.78);
    canvas.drawPath(diagonal, accentPaint);
  }

  @override
  bool shouldRepaint(final _HeroRunwayPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dark != dark;
  }
}

class _HeroScanLine extends StatelessWidget {
  const _HeroScanLine({required this.color});

  final Color color;

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _HeroProgressDots extends StatelessWidget {
  const _HeroProgressDots({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        for (int index = 0; index < count; index++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: index == activeIndex ? 22 : 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index == activeIndex
                  ? AppColors.primaryColor
                  : Colors.white.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
      ],
    );
  }
}

class _StageBeam extends StatelessWidget {
  const _StageBeam({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return Transform.rotate(
      angle: -0.34,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Reveal extends StatefulWidget {
  const _Reveal({
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.18),
  });

  final Widget child;
  final Duration delay;
  final Offset beginOffset;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    const Duration duration = Duration(milliseconds: 680);
    final Curve curve = Curves.easeOutCubic;

    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.beginOffset,
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: widget.child,
      ),
    );
  }
}

class _ScrollReveal extends StatefulWidget {
  const _ScrollReveal({
    required this.child,
    this.beginOffset = const Offset(0, 0.08),
    this.delay = Duration.zero,
    this.initialScale = 0.985,
  });

  final Widget child;
  final Offset beginOffset;
  final Duration delay;
  final double initialScale;

  @override
  State<_ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<_ScrollReveal> {
  ScrollPosition? _position;
  bool _visible = false;
  bool _scheduled = false;
  bool _waitingForDelay = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollPosition? nextPosition = Scrollable.maybeOf(context)?.position;
    if (_position != nextPosition) {
      _position?.removeListener(_scheduleVisibilityCheck);
      _position = nextPosition;
      _position?.addListener(_scheduleVisibilityCheck);
    }
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _position?.removeListener(_scheduleVisibilityCheck);
    super.dispose();
  }

  void _scheduleVisibilityCheck() {
    if (_scheduled || _visible) {
      return;
    }
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _updateVisibility();
    });
  }

  void _updateVisibility() {
    if (!mounted || _visible) {
      return;
    }
    final ScrollableState? scrollable = Scrollable.maybeOf(context);
    final RenderObject? itemObject = context.findRenderObject();
    final RenderObject? viewportObject = scrollable?.context.findRenderObject();

    if (itemObject is! RenderBox || viewportObject is! RenderBox) {
      return;
    }
    if (!itemObject.attached || !viewportObject.attached) {
      return;
    }

    final double itemTop =
        itemObject.localToGlobal(Offset.zero, ancestor: viewportObject).dy;
    final double viewportHeight = viewportObject.size.height;
    if (itemTop < viewportHeight * 0.88) {
      if (widget.delay > Duration.zero) {
        if (_waitingForDelay) {
          return;
        }
        _waitingForDelay = true;
        Future<void>.delayed(widget.delay, () {
          if (mounted && !_visible) {
            setState(() => _visible = true);
          }
        });
        return;
      }
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : widget.beginOffset,
      duration: const Duration(milliseconds: 640),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 640),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: _visible ? 1 : widget.initialScale,
          duration: const Duration(milliseconds: 640),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

class _FeaturedWorkShowcase extends StatelessWidget {
  const _FeaturedWorkShowcase();

  @override
  Widget build(final BuildContext context) {
    final List<_FeaturedProject> projects = [
      const _FeaturedProject(
        eyebrow: 'Scholarship technology',
        title: 'BoursePad',
        summary:
            'A live education technology app for scholarship discovery, applications, verification, messaging, and mobile releases.',
        problem:
            'The live scholarship app needed steady feature delivery, reliable releases, and long-term mobile support.',
        built:
            'Feature-based Flutter architecture, Riverpod, GoRouter, Firebase data flows, CI/CD, and native Swift/Kotlin integration.',
        impact:
            'Cleaner architecture, safer releases, and stronger production support.',
        screenPaths: [
          'assets/images/boursepad-mockup.png',
          'assets/images/boursepad-detail-mockup.png',
          'assets/images/boursepad-applications-mockup.png',
        ],
        chips: [
          'Flutter',
          'Riverpod',
          'GoRouter',
          'Cloud Messaging',
          'CI/CD',
          'Store release',
        ],
        appStoreUrl: 'https://apps.apple.com/us/app/boursepad/id6738283933',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.eruditio.boursepad',
      ),
      const _FeaturedProject(
        eyebrow: 'Construction technology',
        title: 'Construction Workforce Platform',
        summary:
            'A multi-role workforce platform for contractor queues, document review, workforce requests, and admin portals.',
        problem:
            'Construction operations needed contractor onboarding, identity checks, request queues, and admin review in one product system.',
        built:
            'Flutter mobile, Flutter Web portals, role-based access, Cloud Storage, event-driven functions, and notification flows.',
        impact:
            'A clearer workflow from document verification to workforce fulfillment.',
        screenPaths: [
          'assets/images/construction-workforce-dashboard-mockup.png',
          'assets/images/construction-documents-mockup.png',
          'assets/images/construction-admin-mockup.png',
        ],
        chips: [
          'Flutter',
          'Flutter Web',
          'Cloud Storage',
          'Cloud Functions',
          'Access control',
          'Notifications',
        ],
      ),
      const _FeaturedProject(
        eyebrow: 'Enterprise retail',
        title: 'Coach Asia POS',
        summary:
            'Mobile POS modernization for retail transactions, inventory workflows, payments, and store peripherals.',
        problem:
            'Retail teams across five Asian markets needed a modern mobile workflow without losing operational reliability.',
        built:
            '.NET APIs, reusable Flutter components, Java/Kotlin integrations, BLE scanners, printers, payments, and deep links.',
        impact:
            'A more flexible store workflow with maintainable modules and steadier release support.',
        screenPaths: [
          'assets/images/retail-pos-mockup.png',
          'assets/images/coach-products-mockup.png',
          'assets/images/coach-payment-mockup.png',
        ],
        chips: [
          'Flutter',
          '.NET APIs',
          'Java',
          'Kotlin',
          'BLE',
          'Payments',
        ],
        externalUrl: 'https://www.chainstoreplus.com/en/products/mpos',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _ScrollReveal(
          child: Column(
            children: [
              _Eyebrow('Selected work'),
              SizedBox(height: Dimens.mediumPadding),
              _ShowcaseTitle(),
            ],
          ),
        ),
        const SizedBox(height: Dimens.extraLargePadding),
        for (int index = 0; index < projects.length; index++) ...[
          _ScrollReveal(
            beginOffset: const Offset(0, 0.1),
            delay: Duration(milliseconds: 90 * index),
            initialScale: 0.975,
            child: _FeaturedProjectSection(
              project: projects[index],
              imageOnRight: index.isEven,
            ),
          ),
          if (index != projects.length - 1)
            const SizedBox(height: Dimens.extraLargePadding),
        ],
      ],
    );
  }
}

class _SupportingProject {
  const _SupportingProject({
    required this.eyebrow,
    required this.title,
    required this.summary,
    required this.highlights,
    required this.screenPaths,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String summary;
  final List<String> highlights;
  final List<String> screenPaths;
  final IconData icon;
}

class _MoreTechnicalWorkStrip extends StatelessWidget {
  const _MoreTechnicalWorkStrip();

  @override
  Widget build(final BuildContext context) {
    final List<_SupportingProject> projects = [
      const _SupportingProject(
        eyebrow: 'Water usage mobile app',
        title: 'KeelWorks Foundation',
        summary:
            'Flutter flows for usage tracking, secure REST API records, BLoC state separation, onboarding, and chart-based conservation insights.',
        highlights: ['BLoC', 'REST APIs', 'Charts'],
        screenPaths: [
          'assets/images/keelworks-overview-mockup.png',
          'assets/images/keelworks-usage-mockup.png',
          'assets/images/keelworks-save-mockup.png',
        ],
        icon: Icons.water_drop_rounded,
      ),
      const _SupportingProject(
        eyebrow: 'AI resume tooling',
        title: 'AI Resume Parser',
        summary:
            'A backend exploration using FastAPI, Elasticsearch retrieval, spaCy parsing, scoring workflows, and Dockerized development support.',
        highlights: ['FastAPI', 'Elasticsearch', 'Docker'],
        screenPaths: [
          'assets/images/ai-parser-upload-mockup.png',
          'assets/images/ai-parser-profile-mockup.png',
          'assets/images/ai-parser-search-mockup.png',
        ],
        icon: Icons.manage_search_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow('More technical work'),
                  const SizedBox(height: Dimens.mediumPadding),
                  Text(
                    'Additional product and backend work',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.08,
                        ),
                  ),
                ],
              ),
            ),
            if (MediaQuery.sizeOf(context).width >= 760)
              Text(
                'KeelWorks and AI Resume Parser',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: Dimens.largePadding),
        LayoutBuilder(
          builder: (final context, final constraints) {
            final bool wide = constraints.maxWidth >= 760;
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int index = 0; index < projects.length; index++) ...[
                    _SupportingProjectCard(project: projects[index]),
                    if (index != projects.length - 1)
                      const SizedBox(height: Dimens.largePadding),
                  ],
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < projects.length; index++) ...[
                  Expanded(
                    child: _SupportingProjectCard(project: projects[index]),
                  ),
                  if (index != projects.length - 1)
                    const SizedBox(width: Dimens.largePadding),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SupportingProjectCard extends StatelessWidget {
  const _SupportingProjectCard({required this.project});

  final _SupportingProject project;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool dark = checkDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: dark ? 0.58 : 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: dark ? 0.22 : 0.36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconFrame(icon: project.icon, color: scheme.primary),
              const SizedBox(width: Dimens.padding),
              Expanded(child: _Eyebrow(project.eyebrow)),
            ],
          ),
          const SizedBox(height: Dimens.largePadding),
          Text(
            project.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
          ),
          const SizedBox(height: Dimens.mediumPadding),
          Text(
            project.summary,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              height: 1.46,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Dimens.largePadding),
          _SupportingScreensStrip(paths: project.screenPaths),
          const SizedBox(height: Dimens.largePadding),
          Wrap(
            spacing: Dimens.padding,
            runSpacing: Dimens.padding,
            children: [
              for (final String highlight in project.highlights)
                _TechPill(label: highlight),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShowcaseTitle extends StatelessWidget {
  const _ShowcaseTitle();

  @override
  Widget build(final BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).width < 600;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Text(
        'Production Flutter projects',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: compact ? 36 : 56,
              fontWeight: FontWeight.w900,
              height: 1.02,
            ),
      ),
    );
  }
}

class _FeaturedProject {
  const _FeaturedProject({
    required this.eyebrow,
    required this.title,
    required this.summary,
    required this.problem,
    required this.built,
    required this.impact,
    required this.screenPaths,
    required this.chips,
    this.appStoreUrl,
    this.playStoreUrl,
    this.externalUrl,
  });

  final String eyebrow;
  final String title;
  final String summary;
  final String problem;
  final String built;
  final String impact;
  final List<String> screenPaths;
  final List<String> chips;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? externalUrl;
}

class _FeaturedProjectSection extends StatelessWidget {
  const _FeaturedProjectSection({
    required this.project,
    required this.imageOnRight,
  });

  final _FeaturedProject project;
  final bool imageOnRight;

  @override
  Widget build(final BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 900;
    final Widget copy = _FeaturedProjectCopy(project: project);
    final Widget visual = _FeaturedProjectVisual(project: project);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: checkDarkMode(context)
            ? const Color(0xff081214)
            : const Color(0xffF6F8F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(
                alpha: 0.22,
              ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(wide ? 52 : Dimens.largePadding),
        child: wide
            ? Row(
                children: imageOnRight
                    ? [
                        Expanded(flex: 9, child: copy),
                        const SizedBox(width: 52),
                        Expanded(flex: 8, child: visual),
                      ]
                    : [
                        Expanded(flex: 8, child: visual),
                        const SizedBox(width: 52),
                        Expanded(flex: 9, child: copy),
                      ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  visual,
                  const SizedBox(height: Dimens.extraLargePadding),
                  copy,
                ],
              ),
      ),
    );
  }
}

class _FeaturedProjectCopy extends StatelessWidget {
  const _FeaturedProjectCopy({required this.project});

  final _FeaturedProject project;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool compact = MediaQuery.sizeOf(context).width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(project.eyebrow),
        const SizedBox(height: Dimens.mediumPadding),
        Text(
          project.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: compact ? 38 : 56,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
        ),
        const SizedBox(height: Dimens.largePadding),
        Text(
          project.summary,
          maxLines: compact ? 4 : 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontSize: compact ? 17 : 20,
                height: 1.5,
              ),
        ),
        const SizedBox(height: Dimens.largePadding),
        _MiniCaseStudy(project: project),
        const SizedBox(height: Dimens.largePadding),
        Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children: [
            for (final String chip in project.chips) _TechPill(label: chip),
          ],
        ),
        const SizedBox(height: Dimens.largePadding),
        Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children: [
            if (project.appStoreUrl != null)
              _StoreBadge(
                icon: Icons.apple_rounded,
                title: 'App Store',
                subtitle: 'Live release',
                onTap: () => _launch(project.appStoreUrl!),
              ),
            if (project.playStoreUrl != null)
              _StoreBadge(
                icon: Icons.shop_rounded,
                title: 'Google Play',
                subtitle: 'Live release',
                onTap: () => _launch(project.playStoreUrl!),
              ),
            if (project.externalUrl != null)
              _StoreBadge(
                icon: Icons.open_in_new_rounded,
                title: 'Project link',
                subtitle: 'External page',
                onTap: () => _launch(project.externalUrl!),
              ),
          ],
        ),
      ],
    );
  }
}

class _MiniCaseStudy extends StatelessWidget {
  const _MiniCaseStudy({required this.project});

  final _FeaturedProject project;

  @override
  Widget build(final BuildContext context) {
    final List<(String, String)> rows = [
      ('Problem', project.problem),
      ('Built', project.built),
      ('Impact', project.impact),
    ];

    return Column(
      children: [
        for (int index = 0; index < rows.length; index++) ...[
          _CaseStudyRow(label: rows[index].$1, value: rows[index].$2),
          if (index != rows.length - 1) const SizedBox(height: Dimens.padding),
        ],
      ],
    );
  }
}

class _CaseStudyRow extends StatelessWidget {
  const _CaseStudyRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: TextStyle(
              color: scheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.9),
              height: 1.36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedProjectVisual extends StatelessWidget {
  const _FeaturedProjectVisual({required this.project});

  final _FeaturedProject project;

  @override
  Widget build(final BuildContext context) {
    return _ProjectScreenStack(paths: project.screenPaths);
  }
}

class _ProjectScreenStack extends StatefulWidget {
  const _ProjectScreenStack({required this.paths});

  final List<String> paths;

  @override
  State<_ProjectScreenStack> createState() => _ProjectScreenStackState();
}

class _ProjectScreenStackState extends State<_ProjectScreenStack>
    with SingleTickerProviderStateMixin {
  static const Curve _turnCurve = Cubic(0.44, 0, 0.18, 1);
  static const Duration _arrowTurnDuration = Duration(milliseconds: 3400);
  static const Duration _dragSettleDuration = Duration(milliseconds: 1600);

  int _activeIndex = 0;
  late final AnimationController _turnController;
  late Animation<double> _turnAnimation;
  double _position = 0;
  double? _dragStartPosition;
  double _dragTravel = 0;

  List<String> get _paths => widget.paths;

  @override
  void initState() {
    super.initState();
    _turnAnimation = AlwaysStoppedAnimation<double>(_position);
    _turnController = AnimationController(
      vsync: this,
      duration: _arrowTurnDuration,
    )..addStatusListener((final status) {
        if (status == AnimationStatus.completed) {
          _finishTurn();
        }
      });
  }

  @override
  void dispose() {
    _turnController.dispose();
    super.dispose();
  }

  void _finishTurn() {
    if (!mounted) {
      return;
    }
    setState(() {
      _position = _turnAnimation.value.roundToDouble();
      _activeIndex = _normalizeIndex(_position.round());
      _position = _activeIndex.toDouble();
      _turnAnimation = AlwaysStoppedAnimation<double>(_position);
      _dragStartPosition = null;
      _dragTravel = 0;
    });
  }

  void _move(final int delta) {
    if (_turnController.isAnimating) {
      return;
    }
    _animateTo(
      _position + delta,
      duration: _arrowTurnDuration,
    );
  }

  void _animateTo(
    final double target, {
    required final Duration duration,
  }) {
    final double start = _position;
    _turnAnimation = Tween<double>(begin: start, end: target).animate(
      CurvedAnimation(parent: _turnController, curve: _turnCurve),
    );
    _turnController.duration = duration;
    _turnController.forward(from: 0);
  }

  void _startDrag() {
    if (_turnController.isAnimating) {
      _turnController.stop();
      _position = _turnAnimation.value;
      _turnAnimation = AlwaysStoppedAnimation<double>(_position);
    }
    _dragStartPosition = _position;
    _dragTravel = 0;
  }

  void _updateDrag(final double delta, final double dragStepWidth) {
    final double? startPosition = _dragStartPosition;
    if (startPosition == null) {
      return;
    }
    _dragTravel += delta;
    setState(() {
      _position = startPosition - (_dragTravel / dragStepWidth);
      _activeIndex = _normalizeIndex(_position.round());
      _turnAnimation = AlwaysStoppedAnimation<double>(_position);
    });
  }

  void _settleDrag(final double velocity) {
    if (_dragStartPosition == null) {
      return;
    }
    double target = _position.roundToDouble();
    if (velocity.abs() > 460) {
      target = (_position + (velocity < 0 ? 0.56 : -0.56)).roundToDouble();
    }
    _dragStartPosition = null;
    if ((target - _position).abs() < 0.01) {
      _finishTurn();
      return;
    }
    _animateTo(
      target,
      duration: _dragSettleDuration,
    );
  }

  int _normalizeIndex(final int index) {
    return (index % _paths.length + _paths.length) % _paths.length;
  }

  double _screenAngle(final int index, final double position) {
    final double step = (math.pi * 2) / _paths.length;
    double angle = (index - position) * step;
    while (angle > math.pi) {
      angle -= math.pi * 2;
    }
    while (angle < -math.pi) {
      angle += math.pi * 2;
    }
    return angle;
  }

  List<int> _paintOrder(final double position) {
    final List<int> indices = List<int>.generate(_paths.length, (final i) => i);
    indices.sort((final a, final b) {
      final double aDepth = _cylinderDepth(_screenAngle(a, position));
      final double bDepth = _cylinderDepth(_screenAngle(b, position));
      return aDepth.compareTo(bDepth);
    });
    return indices;
  }

  double _cylinderDepth(final double angle) {
    return math.cos(angle);
  }

  int _directionFor(final int index, final double position) {
    final double angle = _screenAngle(index, position);
    if (angle == 0) {
      return 0;
    }
    return angle > 0 ? 1 : -1;
  }

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final bool stacked = constraints.maxWidth >= 390 && _paths.length >= 3;
        if (!stacked) {
          return _ScreenScroller(paths: _paths, width: 178);
        }

        final double maxWidth = constraints.maxWidth;
        final double centerWidth = maxWidth < 430 ? 214 : 232;
        final double radius = maxWidth < 430 ? 142 : 178;
        final double dragStepWidth = maxWidth < 430 ? 190 : 240;

        return SizedBox(
          height: 430,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (_) => _startDrag(),
            onHorizontalDragUpdate: (final details) {
              _updateDrag(details.primaryDelta ?? 0, dragStepWidth);
            },
            onHorizontalDragEnd: (final details) {
              _settleDrag(details.primaryVelocity ?? 0);
            },
            onHorizontalDragCancel: () => _settleDrag(0),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: AnimatedBuilder(
                animation: _turnController,
                builder: (final context, final child) {
                  final double position = _turnAnimation.value;
                  return Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 8,
                        child: Container(
                          height: 112,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primaryColor.withValues(alpha: 0.22),
                                Colors.black.withValues(alpha: 0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      for (final int screenIndex in _paintOrder(position))
                        _ProjectCarouselScreen(
                          key: ValueKey<String>(_paths[screenIndex]),
                          path: _paths[screenIndex],
                          angle: _screenAngle(screenIndex, position),
                          stackWidth: maxWidth,
                          centerWidth: centerWidth,
                          radius: radius,
                          onTap: screenIndex == _activeIndex
                              ? null
                              : () =>
                                  _move(_directionFor(screenIndex, position)),
                        ),
                      Positioned(
                        left: 8,
                        top: 170,
                        child: _ProjectCarouselButton(
                          tooltip: 'Previous screen',
                          icon: Icons.chevron_left_rounded,
                          onTap: () => _move(-1),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 170,
                        child: _ProjectCarouselButton(
                          tooltip: 'Next screen',
                          icon: Icons.chevron_right_rounded,
                          onTap: () => _move(1),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: _HeroProgressDots(
                          count: _paths.length,
                          activeIndex: _activeIndex,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProjectCarouselScreen extends StatelessWidget {
  const _ProjectCarouselScreen({
    super.key,
    required this.path,
    required this.angle,
    required this.stackWidth,
    required this.centerWidth,
    required this.radius,
    required this.onTap,
  });

  final String path;
  final double angle;
  final double stackWidth;
  final double centerWidth;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final double depth = math.cos(angle);
    final double normalizedDepth = ((depth + 1) / 2).clamp(0.0, 1.0);
    final double x = math.sin(angle) * radius;
    final double scale = 0.64 + (normalizedDepth * 0.36);
    final double top = 8 + ((1 - normalizedDepth) * 72);
    final double opacity = 0.32 + (normalizedDepth * 0.68);
    final Matrix4 cylinderTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.0019)
      ..rotateY(-angle * 0.36);

    return Positioned(
      left: (stackWidth - centerWidth) / 2,
      top: top,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(x, 0),
          child: Transform(
            alignment: Alignment.center,
            transform: cylinderTransform,
            child: Transform.scale(
              scale: scale,
              child: MouseRegion(
                cursor: onTap == null
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTap,
                  child: _ScreenPhoneFrame(
                    path: path,
                    width: centerWidth,
                    opacity: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCarouselButton extends StatelessWidget {
  const _ProjectCarouselButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(
        style: IconButton.styleFrom(
          fixedSize: const Size(38, 38),
          backgroundColor: Colors.black.withValues(alpha: 0.58),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 22),
      ),
    );
  }
}

class _ScreenScroller extends StatelessWidget {
  const _ScreenScroller({
    required this.paths,
    required this.width,
  });

  final List<String> paths;
  final double width;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int index = 0; index < paths.length; index++) ...[
            _ScreenPhoneFrame(path: paths[index], width: width),
            if (index != paths.length - 1)
              const SizedBox(width: Dimens.mediumPadding),
          ],
        ],
      ),
    );
  }
}

class _ScreenPhoneFrame extends StatelessWidget {
  const _ScreenPhoneFrame({
    required this.path,
    required this.width,
    this.opacity = 1,
  });

  final String path;
  final double width;
  final double opacity;

  @override
  Widget build(final BuildContext context) {
    final double outerRadius = width * 0.115;
    final double innerRadius = width * 0.09;

    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.032),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(outerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.34),
              blurRadius: width * 0.12,
              offset: Offset(0, width * 0.07),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Image.asset(
              path,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportingScreensStrip extends StatelessWidget {
  const _SupportingScreensStrip({required this.paths});

  final List<String> paths;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 214,
      child: _ScreenScroller(paths: paths, width: 108),
    );
  }
}

class _StoreBadge extends StatelessWidget {
  const _StoreBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: 158,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.mediumPadding,
          vertical: Dimens.padding,
        ),
        decoration: BoxDecoration(
          color: scheme.onSurface.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.26),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: scheme.onSurface, size: 22),
            const SizedBox(width: Dimens.padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesignLensStrip extends StatelessWidget {
  const _DesignLensStrip();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<DesignLens> lenses = _homeContent(context).designLenses;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(
          alpha: checkDarkMode(context) ? 0.54 : 0.72,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final bool wide = constraints.maxWidth >= 900;
          final int columns = wide
              ? 4
              : constraints.maxWidth >= 560
                  ? 2
                  : 1;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lenses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: Dimens.largePadding,
              crossAxisSpacing: Dimens.largePadding,
              childAspectRatio: wide
                  ? 2.35
                  : columns == 2
                      ? 1.65
                      : 2.35,
            ),
            itemBuilder: (final context, final index) {
              return _DesignLensItem(lens: lenses[index]);
            },
          );
        },
      ),
    );
  }
}

class _DesignLensItem extends StatelessWidget {
  const _DesignLensItem({required this.lens});

  final DesignLens lens;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(lens.icon.icon, color: scheme.primary, size: 24),
        const SizedBox(height: Dimens.mediumPadding),
        Text(
          lens.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: Dimens.smallPadding),
        Text(
          lens.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            height: 1.32,
          ),
        ),
      ],
    );
  }
}

class _IconFrame extends StatelessWidget {
  const _IconFrame({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 900;
    final AboutProfile about = _homeContent(context).about;

    return _SectionScaffold(
      eyebrow: about.eyebrow,
      title: about.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _AboutSummary(summary: about.summary),
                ),
                const SizedBox(width: Dimens.extraLargePadding),
                Expanded(flex: 4, child: _InfoPanel(rows: about.info)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutSummary(summary: about.summary),
                const SizedBox(height: Dimens.largePadding),
                _InfoPanel(rows: about.info),
              ],
            ),
          const SizedBox(height: Dimens.extraLargePadding),
          const _StatsGrid(),
        ],
      ),
    );
  }
}

class _AboutSummary extends StatelessWidget {
  const _AboutSummary({required this.summary});

  final String summary;

  @override
  Widget build(final BuildContext context) {
    return Text(
      summary,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.58),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.rows});

  final List<ProfileInfo> rows;

  @override
  Widget build(final BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          for (final ProfileInfo row in rows) _InfoRow(row.label, row.value),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.mediumPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(final BuildContext context) {
    final List<PortfolioStat> stats = _homeContent(context).stats;

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final int columns = constraints.maxWidth > 840 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: Dimens.mediumPadding,
            crossAxisSpacing: Dimens.mediumPadding,
            childAspectRatio: columns == 4 ? 1.35 : 0.92,
          ),
          itemBuilder: (final context, final index) {
            return _StatCard(stat: stats[index]);
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final PortfolioStat stat;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(stat.icon.icon, color: scheme.primary, size: 22),
          const SizedBox(height: Dimens.mediumPadding),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: Dimens.smallPadding),
          Text(
            stat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              height: 1.24,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeView extends StatelessWidget {
  const _ResumeView();

  @override
  Widget build(final BuildContext context) {
    final List<Experience> experiences = _homeContent(context).experiences;
    final List<PortfolioStat> stats = _homeContent(context).stats;
    final CoreCompetencies competencies =
        _homeContent(context).coreCompetencies;

    return _SectionScaffold(
      eyebrow: competencies.sectionEyebrow,
      title: competencies.sectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResumeSnapshot(stats: stats),
          const SizedBox(height: Dimens.extraLargePadding),
          _CoreCompetenciesCard(competencies: competencies),
          const SizedBox(height: Dimens.extraLargePadding),
          _ExperienceTimeline(experiences: experiences),
        ],
      ),
    );
  }
}

class _ResumeSnapshot extends StatelessWidget {
  const _ResumeSnapshot({required this.stats});

  final List<PortfolioStat> stats;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Eyebrow('Experience overview'),
          const SizedBox(height: Dimens.mediumPadding),
          Text(
            'Career summary',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
          ),
          const SizedBox(height: Dimens.largePadding),
          LayoutBuilder(
            builder: (final context, final constraints) {
              final int columns = constraints.maxWidth >= 860 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: Dimens.padding,
                  crossAxisSpacing: Dimens.padding,
                  childAspectRatio: columns == 4 ? 2.65 : 1.68,
                ),
                itemBuilder: (final context, final index) {
                  return _ResumeSnapshotTile(
                    stat: stats[index],
                    accent: index == 1 ? AppColors.secondColor : scheme.primary,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ResumeSnapshotTile extends StatelessWidget {
  const _ResumeSnapshotTile({
    required this.stat,
    required this.accent,
  });

  final PortfolioStat stat;
  final Color accent;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Dimens.mediumPadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          _IconFrame(icon: stat.icon.icon, color: accent),
          const SizedBox(width: Dimens.mediumPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                ),
                const SizedBox(height: Dimens.smallPadding),
                Text(
                  stat.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoreCompetenciesCard extends StatelessWidget {
  const _CoreCompetenciesCard({required this.competencies});

  final CoreCompetencies competencies;

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 820;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow(competencies.cardEyebrow),
          const SizedBox(height: Dimens.mediumPadding),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _CoreCompetenciesIntro(competencies: competencies),
                ),
                const SizedBox(width: Dimens.extraLargePadding),
                Expanded(
                  flex: 4,
                  child: _ImpactGrid(
                    impacts: competencies.impacts,
                    accent: scheme.primary,
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CoreCompetenciesIntro(competencies: competencies),
                const SizedBox(height: Dimens.largePadding),
                _ImpactGrid(
                  impacts: competencies.impacts,
                  accent: scheme.primary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CoreCompetenciesIntro extends StatelessWidget {
  const _CoreCompetenciesIntro({required this.competencies});

  final CoreCompetencies competencies;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          competencies.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                height: 1.02,
              ),
        ),
        const SizedBox(height: Dimens.padding),
        Text(
          competencies.subtitle,
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: Dimens.largePadding),
        Text(
          competencies.description,
          style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: Dimens.largePadding),
        Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children: [
            for (final String badge in competencies.badges) _MiniBadge(badge),
          ],
        ),
      ],
    );
  }
}

class _ImpactGrid extends StatelessWidget {
  const _ImpactGrid({required this.impacts, required this.accent});

  final List<CompetencyImpact> impacts;
  final Color accent;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final bool wide = constraints.maxWidth > 360;
        final List<Widget> cards = [
          for (final CompetencyImpact impact in impacts)
            _ImpactCard(
              icon: impact.icon.icon,
              title: impact.title,
              text: impact.description,
              color: accent,
            ),
        ];

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final Widget card in cards)
                Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.padding),
                  child: card,
                ),
            ],
          );
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: Dimens.padding,
          mainAxisSpacing: Dimens.padding,
          childAspectRatio: 1.45,
          children: cards,
        );
      },
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.mediumPadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: scheme.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: Dimens.padding),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: Dimens.smallPadding),
          Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12,
              height: 1.28,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceTimeline extends StatelessWidget {
  const _ExperienceTimeline({required this.experiences});

  final List<Experience> experiences;

  @override
  Widget build(final BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 860;
    final Size viewport = MediaQuery.sizeOf(context);
    final bool stickyRail = viewport.width >= 960 && viewport.height >= 600;

    if (!wide) {
      return Column(
        children: [
          for (final Experience experience in experiences)
            Padding(
              padding: const EdgeInsets.only(bottom: Dimens.largePadding),
              child: _ExperienceCard(experience: experience),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('Experience timeline'),
        const SizedBox(height: Dimens.largePadding),
        for (int index = 0; index < experiences.length; index++)
          _TimelineExperienceItem(
            experience: experiences[index],
            isFirst: index == 0,
            isLast: index == experiences.length - 1,
            useStickyMeta: stickyRail,
          ),
      ],
    );
  }
}

class _TimelineExperienceItem extends StatelessWidget {
  const _TimelineExperienceItem({
    required this.experience,
    required this.isFirst,
    required this.isLast,
    required this.useStickyMeta,
  });

  final Experience experience;
  final bool isFirst;
  final bool isLast;
  final bool useStickyMeta;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: useStickyMeta ? 236 : 180,
            child: useStickyMeta
                ? _StickyTimelineMeta(experience: experience)
                : _TimelineInlineMeta(experience: experience),
          ),
          const SizedBox(width: Dimens.largePadding),
          Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.28),
                  ),
                ),
                child: Icon(
                  _experienceIcon(experience.company),
                  color: scheme.primary,
                  size: 22,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                      vertical: Dimens.padding,
                    ),
                    color: scheme.outlineVariant.withValues(alpha: 0.36),
                  ),
                ),
            ],
          ),
          const SizedBox(width: Dimens.largePadding),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : Dimens.extraLargePadding,
              ),
              child: _ExperienceCard(
                experience: experience,
                showHeaderPeriod: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineInlineMeta extends StatelessWidget {
  const _TimelineInlineMeta({required this.experience});

  final Experience experience;

  @override
  Widget build(final BuildContext context) {
    return _TimelineMetaCard(
      experience: experience,
      elevated: false,
    );
  }
}

class _StickyTimelineMeta extends StatefulWidget {
  const _StickyTimelineMeta({required this.experience});

  final Experience experience;

  @override
  State<_StickyTimelineMeta> createState() => _StickyTimelineMetaState();
}

class _StickyTimelineMetaState extends State<_StickyTimelineMeta> {
  static const double _cardHeight = 164;

  final GlobalKey _measurementKey = GlobalKey();
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition = Scrollable.maybeOf(context)?.position;
  }

  @override
  Widget build(final BuildContext context) {
    final Listenable scrollSignal =
        _scrollPosition ?? const AlwaysStoppedAnimation<double>(0);

    return KeyedSubtree(
      key: _measurementKey,
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final double sectionHeight = constraints.hasBoundedHeight
              ? constraints.maxHeight
              : _cardHeight;

          return SizedBox(
            height: sectionHeight,
            child: AnimatedBuilder(
              animation: scrollSignal,
              builder: (final context, final child) {
                final double maxTop = math.max(
                  0,
                  sectionHeight - _cardHeight,
                );
                double top = 0;
                final RenderBox? box = _measurementKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                if (box != null && box.hasSize && box.attached) {
                  final double globalTop = box.localToGlobal(Offset.zero).dy;
                  final double viewportHeight = MediaQuery.sizeOf(
                    context,
                  ).height;
                  final double anchorY =
                      viewportHeight - _cardHeight - Dimens.extraLargePadding;
                  top = (anchorY - globalTop).clamp(0.0, maxTop);
                }

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: child!,
                    ),
                  ],
                );
              },
              child: _TimelineMetaCard(
                experience: widget.experience,
                elevated: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimelineMetaCard extends StatelessWidget {
  const _TimelineMetaCard({
    required this.experience,
    required this.elevated,
  });

  final Experience experience;
  final bool elevated;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: elevated ? _StickyTimelineMetaState._cardHeight : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: elevated ? 0.9 : 0),
          borderRadius: BorderRadius.circular(8),
          border: elevated
              ? Border.all(color: scheme.primary.withValues(alpha: 0.24))
              : null,
          boxShadow: elevated
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 18),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.24),
                    blurRadius: 34,
                    offset: const Offset(0, 18),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(elevated ? Dimens.mediumPadding : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _MiniBadge(experience.period),
              const SizedBox(height: Dimens.padding),
              Text(
                _timelineSummary(experience.company),
                style: TextStyle(
                  color: elevated ? scheme.onSurface : scheme.onSurfaceVariant,
                  height: 1.22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (elevated) ...[
                const SizedBox(height: Dimens.padding),
                Text(
                  experience.company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({
    required this.experience,
    this.showHeaderPeriod = true,
  });

  final Experience experience;
  final bool showHeaderPeriod;

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 760;
    final bool mergedTimelineHeader = isWide && !showHeaderPeriod;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mergedTimelineHeader)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ExperienceMergedHeader(experience: experience),
                const SizedBox(height: Dimens.largePadding),
                _ExperienceDetails(
                  experience: experience,
                  showRole: false,
                ),
              ],
            )
          else if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: _ExperienceHeader(
                    experience: experience,
                    showPeriod: showHeaderPeriod,
                  ),
                ),
                const SizedBox(width: Dimens.extraLargePadding),
                Expanded(
                  child: _ExperienceDetails(experience: experience),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ExperienceHeader(
                  experience: experience,
                  showPeriod: showHeaderPeriod,
                ),
                const SizedBox(height: Dimens.largePadding),
                _ExperienceDetails(experience: experience),
              ],
            ),
          if (experience.links.isNotEmpty) ...[
            const SizedBox(height: Dimens.largePadding),
            Wrap(
              spacing: Dimens.padding,
              runSpacing: Dimens.padding,
              children: [
                for (final ResumeLink link in experience.links)
                  _TextLink(label: link.label, onTap: () => _launch(link.url)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExperienceHeader extends StatelessWidget {
  const _ExperienceHeader({
    required this.experience,
    required this.showPeriod,
  });

  final Experience experience;
  final bool showPeriod;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPeriod) ...[
          _MiniBadge(experience.period),
          const SizedBox(height: Dimens.mediumPadding),
        ],
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          ),
          child: Icon(
            _experienceIcon(experience.company),
            color: scheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: Dimens.largePadding),
        Text(
          experience.company,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: Dimens.smallPadding),
        Text(
          experience.location,
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ExperienceMergedHeader extends StatelessWidget {
  const _ExperienceMergedHeader({required this.experience});

  final Experience experience;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.company,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                    ),
              ),
              const SizedBox(height: Dimens.smallPadding),
              Text(
                experience.role,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimens.largePadding),
        Flexible(
          child: Text(
            experience.location,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _ExperienceDetails extends StatelessWidget {
  const _ExperienceDetails({
    required this.experience,
    this.showRole = true,
  });

  final Experience experience;
  final bool showRole;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRole)
          Text(
            experience.role,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        if (_experienceHighlight(experience.company) case final highlight?) ...[
          const SizedBox(height: Dimens.mediumPadding),
          _ExperienceHighlightBanner(highlight: highlight),
        ],
        const SizedBox(height: Dimens.mediumPadding),
        for (final String point in experience.points)
          _CaseStudyPoint(point: point),
        if (experience.screenPaths.isNotEmpty) ...[
          const SizedBox(height: Dimens.largePadding),
          const _Eyebrow('Project screens'),
          const SizedBox(height: Dimens.mediumPadding),
          _SupportingScreensStrip(paths: experience.screenPaths),
        ],
        const SizedBox(height: Dimens.mediumPadding),
        Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children: [
            for (final String tech in experience.tech) _TechPill(label: tech),
          ],
        ),
      ],
    );
  }
}

class _ExperienceHighlightBanner extends StatelessWidget {
  const _ExperienceHighlightBanner({required this.highlight});

  final String highlight;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.mediumPadding,
        vertical: Dimens.padding,
      ),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: scheme.primary, size: 19),
          const SizedBox(width: Dimens.padding),
          Expanded(
            child: Text(
              highlight,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w900,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseStudyPoint extends StatelessWidget {
  const _CaseStudyPoint({required this.point});

  final String point;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final int splitIndex = point.indexOf(':');
    final bool hasLabel = splitIndex > 0 && splitIndex < 22;
    final String? label = hasLabel ? point.substring(0, splitIndex) : null;
    final String body =
        hasLabel ? point.substring(splitIndex + 1).trim() : point;
    final String accentSource = label ?? body;
    final Color accent = _caseAccent(accentSource, scheme);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimens.padding),
      padding: const EdgeInsets.all(Dimens.mediumPadding),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(
          alpha: checkDarkMode(context) ? 0.32 : 0.48,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _caseIcon(accentSource),
              color: accent,
              size: 19,
            ),
          ),
          const SizedBox(width: Dimens.mediumPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null) ...[
                  Text(
                    label,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: Dimens.smallPadding),
                ],
                Text(
                  body,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    height: 1.46,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillsView extends StatelessWidget {
  const _SkillsView();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<CapabilityGroup> capabilityGroups =
        _homeContent(context).capabilityGroups;
    final List<String> allSkills = _homeContent(context).allSkills;
    final SkillsOverview overview = _homeContent(context).skillsOverview;

    return _SectionScaffold(
      eyebrow: overview.eyebrow,
      title: overview.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Text(
              overview.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: Dimens.extraLargePadding),
          LayoutBuilder(
            builder: (final context, final constraints) {
              final bool twoColumns = constraints.maxWidth >= 860;
              final double spacing = Dimens.largePadding;
              final double cardWidth = twoColumns
                  ? (constraints.maxWidth - spacing) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final CapabilityGroup group in capabilityGroups)
                    SizedBox(
                      width: cardWidth,
                      child: _CapabilityCard(group: group),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: Dimens.extraLargePadding),
          Text(
            overview.toolboxTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: Dimens.largePadding),
          Wrap(
            spacing: Dimens.padding,
            runSpacing: Dimens.padding,
            children: [
              for (final String skill in allSkills) _TechPill(label: skill),
            ],
          ),
        ],
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({required this.group});

  final CapabilityGroup group;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconFrame(icon: group.icon.icon, color: scheme.primary),
              const SizedBox(width: Dimens.mediumPadding),
              Expanded(
                child: Text(
                  group.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.largePadding),
          Text(
            group.description,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              height: 1.46,
            ),
          ),
          const SizedBox(height: Dimens.largePadding),
          Wrap(
            spacing: Dimens.padding,
            runSpacing: Dimens.padding,
            children: [
              for (final String skill in group.skills) _TechPill(label: skill),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(final BuildContext context) {
    return _SectionScaffold(
      eyebrow: 'Preferences',
      title: t.home_screen.settings,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            _SettingTile(
              icon: checkDarkMode(context)
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              title: t.home_screen.themeMode,
              trailing: Switch(
                value: checkDarkMode(context),
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
              onTap: () => context.read<ThemeCubit>().toggleTheme(),
            ),
            const SizedBox(height: Dimens.mediumPadding),
            _SettingTile(
              icon: Icons.translate_rounded,
              title: t.home_screen.language,
              subtitle: LocaleHandler().getLocaleTitle(context),
              trailing: const Icon(Icons.keyboard_arrow_down_rounded),
              onTap: () => _changeLanguageDialog(context),
            ),
            const SizedBox(height: Dimens.mediumPadding),
            _SettingTile(
              icon: Icons.palette_rounded,
              title: t.home_screen.themeColor,
              trailing: Wrap(
                spacing: Dimens.padding,
                children: [
                  _ColorDot(
                    color: AppColors.primaryColor,
                    onTap: () =>
                        context.read<PrimaryColorCubit>().setPurpleColor(),
                  ),
                  _ColorDot(
                    color: Colors.blue,
                    onTap: () =>
                        context.read<PrimaryColorCubit>().setBlueColor(),
                  ),
                  _ColorDot(
                    color: Colors.green,
                    onTap: () =>
                        context.read<PrimaryColorCubit>().setGreenColor(),
                  ),
                  _ColorDot(
                    color: Colors.red,
                    onTap: () =>
                        context.read<PrimaryColorCubit>().setRedColor(),
                  ),
                ],
              ),
              onTap: () => context.read<PrimaryColorCubit>().setPurpleColor(),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguageDialog(final BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (final BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(t.home_screen.french),
                trailing:
                    !checkEnState(context) ? const Icon(Icons.check) : null,
                onTap: () {
                  context.pop();
                  LocaleHandler().setFaLocale(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(t.home_screen.english),
                trailing:
                    checkEnState(context) ? const Icon(Icons.check) : null,
                onTap: () {
                  context.pop();
                  LocaleHandler().setEnLocale(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.corners),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: Dimens.largePadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Tooltip(
      message: 'Select color',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.16),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactStrip extends StatelessWidget {
  const _ContactStrip({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<ContactAction> actions = _homeContent(context).contactActions;
    final ContactAction email = actions.firstWhere(
      (final action) => action.label == 'Email',
      orElse: () => actions.last,
    );

    if (compact) {
      return Wrap(
        spacing: Dimens.padding,
        runSpacing: Dimens.padding,
        children: [
          for (final ContactAction action in actions)
            IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
              ),
              tooltip: action.label,
              onPressed: () => _launch(action.url),
              icon: _ContactActionIcon(action: action, size: 20),
            ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.extraLargePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(
          alpha: checkDarkMode(context) ? 0.64 : 0.78,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final bool wide = constraints.maxWidth >= 780;
          final Widget copy = Column(
            crossAxisAlignment:
                wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              const _Eyebrow('Contact'),
              const SizedBox(height: Dimens.mediumPadding),
              Text(
                'Need a reliable Flutter app from prototype to release?',
                textAlign: wide ? TextAlign.start : TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.04,
                    ),
              ),
              const SizedBox(height: Dimens.mediumPadding),
              Text(
                'I can help with product architecture, native integrations, Firebase, CI/CD, and App Store / Google Play release workflows.',
                textAlign: wide ? TextAlign.start : TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
              ),
            ],
          );
          final Widget buttons = _ContactActionsPanel(
            email: email,
            actions: actions
                .where((final ContactAction action) => action.label != 'Email')
                .toList(growable: false),
          );

          if (!wide) {
            return Column(
              children: [
                copy,
                const SizedBox(height: Dimens.extraLargePadding),
                buttons,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 7, child: copy),
              const SizedBox(width: Dimens.extraLargePadding),
              Expanded(flex: 5, child: buttons),
            ],
          );
        },
      ),
    );
  }
}

class _ContactActionsPanel extends StatelessWidget {
  const _ContactActionsPanel({
    required this.email,
    required this.actions,
  });

  final ContactAction email;
  final List<ContactAction> actions;

  @override
  Widget build(final BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 58,
              child: FilledButton.icon(
                onPressed: () => _launch(email.url),
                icon: const Icon(Icons.mail_rounded),
                label: const Text('Start a conversation'),
                style: FilledButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.padding),
            for (int index = 0; index < actions.length; index += 2) ...[
              Row(
                children: [
                  Expanded(child: _SocialButton(action: actions[index])),
                  const SizedBox(width: Dimens.padding),
                  Expanded(
                    child: index + 1 < actions.length
                        ? _SocialButton(action: actions[index + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              if (index + 2 < actions.length)
                const SizedBox(height: Dimens.padding),
            ],
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.action});

  final ContactAction action;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () => _launch(action.url),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.46),
          ),
          foregroundColor: scheme.onSurface,
          textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
              child: _ContactActionIcon(action: action, size: 15),
            ),
            const SizedBox(width: Dimens.smallPadding),
            Flexible(
              child: Text(
                action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactActionIcon extends StatelessWidget {
  const _ContactActionIcon({
    required this.action,
    required this.size,
  });

  final ContactAction action;
  final double size;

  @override
  Widget build(final BuildContext context) {
    if (action.logoPath == null) {
      return Icon(action.icon.icon, color: Colors.white, size: size);
    }

    return ImageIcon(
      AssetImage(action.logoPath!),
      color: Colors.white,
      size: size,
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(
          alpha: checkDarkMode(context) ? 0.56 : 0.62,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: checkDarkMode(context) ? 0.08 : 0.03,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge(this.label);

  final String label;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.mediumPadding,
          vertical: Dimens.smallPadding,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _TechPill extends StatelessWidget {
  const _TechPill({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.mediumPadding,
          vertical: Dimens.padding,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.open_in_new_rounded),
      label: Text(label),
    );
  }
}

IconData _experienceIcon(final String company) {
  final String normalized = company.toLowerCase();
  if (normalized.contains('bourse')) {
    return Icons.school_rounded;
  }
  if (normalized.contains('keel')) {
    return Icons.water_drop_rounded;
  }
  if (normalized.contains('independent') ||
      normalized.contains('construction')) {
    return Icons.engineering_rounded;
  }
  if (normalized.contains('computer') || normalized.contains('technologies')) {
    return Icons.storefront_rounded;
  }
  if (normalized.contains('resume')) {
    return Icons.manage_search_rounded;
  }
  return Icons.apps_rounded;
}

String _timelineSummary(final String company) {
  final String normalized = company.toLowerCase();
  if (normalized.contains('bourse')) {
    return 'Education technology platform';
  }
  if (normalized.contains('independent') ||
      normalized.contains('construction')) {
    return 'Construction platform delivery';
  }
  if (normalized.contains('keel')) {
    return 'Mobile conservation flows';
  }
  if (normalized.contains('computer') || normalized.contains('technologies')) {
    return 'Coach Asia POS work';
  }
  if (normalized.contains('resume')) {
    return 'Backend AI exploration';
  }
  return 'Mobile product work';
}

String? _experienceHighlight(final String company) {
  final String normalized = company.toLowerCase();
  if (normalized.contains('bourse')) {
    return 'Primary mobile developer for a live education platform with CI/CD, Firebase, and iOS/Android release ownership.';
  }
  if (normalized.contains('independent') ||
      normalized.contains('construction')) {
    return 'Full-stack construction workforce platform across Flutter mobile, Flutter Web, Firebase, Cloud Storage, and Cloud Functions.';
  }
  if (normalized.contains('keel')) {
    return 'Real-time water usage monitoring with dashboards, charts, secure REST APIs, and BLoC module separation.';
  }
  if (normalized.contains('computer') || normalized.contains('technologies')) {
    return 'Enterprise retail POS modernization across five Asian markets with .NET APIs, native Android integrations, peripherals, and payments.';
  }
  if (normalized.contains('resume')) {
    return 'Dockerized FastAPI backend for parsing, contextual skill matching, scoring, search, and retrieval.';
  }
  return null;
}

IconData _caseIcon(final String label) {
  final String normalized = label.toLowerCase();
  if (normalized.contains('problem')) {
    return Icons.error_outline_rounded;
  }
  if (normalized.contains('contribution') ||
      normalized.contains('developed') ||
      normalized.contains('delivered') ||
      normalized.contains('implemented')) {
    return Icons.construction_rounded;
  }
  if (normalized.contains('release') ||
      normalized.contains('deployment') ||
      normalized.contains('ci/cd')) {
    return Icons.rocket_launch_rounded;
  }
  if (normalized.contains('native') || normalized.contains('device')) {
    return Icons.settings_input_component_rounded;
  }
  if (normalized.contains('firebase') ||
      normalized.contains('cloud') ||
      normalized.contains('api')) {
    return Icons.cloud_done_rounded;
  }
  if (normalized.contains('design') ||
      normalized.contains('architecture') ||
      normalized.contains('structured')) {
    return Icons.account_tree_rounded;
  }
  if (normalized.contains('outcome') ||
      normalized.contains('own') ||
      normalized.contains('lead')) {
    return Icons.check_circle_rounded;
  }
  return Icons.auto_awesome_rounded;
}

Color _caseAccent(final String label, final ColorScheme scheme) {
  final String normalized = label.toLowerCase();
  if (normalized.contains('problem')) {
    return AppColors.colorAttention;
  }
  if (normalized.contains('release') ||
      normalized.contains('deployment') ||
      normalized.contains('ci/cd')) {
    return AppColors.secondColor;
  }
  if (normalized.contains('native') || normalized.contains('device')) {
    return scheme.tertiary;
  }
  if (normalized.contains('firebase') ||
      normalized.contains('cloud') ||
      normalized.contains('api')) {
    return scheme.primary;
  }
  if (normalized.contains('outcome') ||
      normalized.contains('own') ||
      normalized.contains('lead')) {
    return AppColors.green;
  }
  return scheme.primary;
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.section);

  final String label;
  final IconData icon;
  final HomeSection section;
}

HomeContent _homeContent(final BuildContext context) {
  final HomeContentState state = context.watch<HomeContentCubit>().state;
  return state.content ?? _emptyHomeContent;
}

const HomeContent _emptyHomeContent = HomeContent(
  hero: HeroProfile(
    role: '',
    eyebrow: '',
    summary: '',
    primaryActionLabel: '',
    secondaryActionLabel: '',
    spotlight: SpotlightSummary(
      title: '',
      value: '',
      description: '',
      icon: HomeIconKey.autoAwesome,
    ),
    metrics: [
      PortfolioStat('', '', HomeIconKey.timeline),
      PortfolioStat('', '', HomeIconKey.android),
    ],
    stack: StackSummary(
      title: '',
      chips: [],
      icon: HomeIconKey.accountTree,
    ),
    highlights: [
      FeatureHighlight(
        title: '',
        description: '',
        icon: HomeIconKey.checkCircle,
      ),
      FeatureHighlight(
        title: '',
        description: '',
        icon: HomeIconKey.bluetooth,
      ),
    ],
  ),
  about: AboutProfile(
    eyebrow: '',
    title: '',
    summary: '',
    info: [],
  ),
  coreCompetencies: CoreCompetencies(
    sectionEyebrow: '',
    sectionTitle: '',
    cardEyebrow: '',
    title: '',
    subtitle: '',
    description: '',
    badges: [],
    impacts: [],
  ),
  skillsOverview: SkillsOverview(
    eyebrow: '',
    title: '',
    description: '',
    toolboxTitle: '',
  ),
  designLenses: [],
  stats: [],
  experiences: [],
  capabilityGroups: [],
  allSkills: [],
  contactActions: [],
);

double _contentInset(
  final BuildContext context, {
  final bool leading = false,
}) {
  final double width = MediaQuery.sizeOf(context).width;
  final double baseInset = switch (width) {
    >= 1200 => Dimens.extraLargePadding * 2,
    >= 700 => Dimens.extraLargePadding,
    _ => Dimens.largePadding,
  };
  if (leading && width >= 960) {
    return baseInset + 132;
  }
  return baseInset;
}

Future<void> _launchMail() async {
  await _launch(
    'mailto:samchancanada1@gmail.com?subject=We%20are%20interested%20in%20you!',
  );
}

Future<void> _launch(final String value) async {
  await launchUrl(Uri.parse(value));
}
