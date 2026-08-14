import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_theme_status.dart';
import '../../../../core/utils/locale_handler.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../bloc/primary_color_cubit.dart';
import '../bloc/theme_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<_NavItem> get _items => [
        _NavItem(t.home_screen.home, Icons.grid_view_rounded),
        _NavItem(t.home_screen.about, Icons.person_pin_rounded),
        _NavItem(t.home_screen.resume, Icons.work_history_rounded),
        _NavItem(t.home_screen.skills, Icons.auto_awesome_motion_rounded),
        _NavItem(t.home_screen.settings, Icons.tune_rounded),
      ];

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 960;
    final List<Widget> sections = [
      const _HomeView(),
      const _AboutView(),
      const _ResumeView(),
      const _SkillsView(),
      const _SettingsView(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.ink,
      body: _PortfolioBackground(
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              if (isWide)
                _SideNavigation(
                  items: _items,
                  selectedIndex: selectedIndex,
                  onSelected: _selectSection,
                ),
              Expanded(
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
                    key: ValueKey<int>(selectedIndex),
                    child: sections[selectedIndex],
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
              items: _items,
              selectedIndex: selectedIndex,
              onSelected: _selectSection,
            ),
    );
  }

  void _selectSection(final int index) {
    setState(() {
      selectedIndex = index;
    });
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
                      Color(0xff061316),
                      Color(0xff11181A),
                      Color(0xff2A2634),
                    ]
                  : const [
                      Color(0xffF8F6EF),
                      Color(0xffEAF5F3),
                      Color(0xffF7EEE7),
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

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
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

    return Container(
      width: 292,
      margin: const EdgeInsets.all(Dimens.largePadding),
      padding: const EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(Dimens.corners),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: AssetImage(Assets.images.profileImage.path),
              ),
              const SizedBox(width: Dimens.mediumPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.home_screen.myName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      'Flutter Mobile Developer',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.extraLargePadding),
          ...List.generate(items.length, (final int index) {
            return _NavButton(
              item: items[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            );
          }),
          const Spacer(),
          _ContactStrip(compact: true),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.padding),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.corners),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimens.corners),
            border: Border.all(
              color: selected
                  ? scheme.primary.withValues(alpha: 0.34)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
                size: 21,
              ),
              const SizedBox(width: Dimens.mediumPadding),
              Text(
                item.label,
                style: TextStyle(
                  color: selected ? scheme.primary : scheme.onSurface,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
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
    final bool compact = MediaQuery.sizeOf(context).width < 600;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            _contentInset(context),
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

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 900;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              _contentInset(context),
              Dimens.extraLargePadding,
              _contentInset(context),
              96,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isWide)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundImage: AssetImage(
                        Assets.images.profileImage.path,
                      ),
                    ),
                  ),
                if (!isWide) const SizedBox(height: Dimens.largePadding),
                _Eyebrow('Markham / Flutter / Clean Architecture / Release'),
                const SizedBox(height: Dimens.largePadding),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Transform.translate(
                          offset: const Offset(0, -96),
                          child: _HomeIntro(
                            mutedColor: scheme.onSurfaceVariant,
                            onViewProjects: () => _jumpTo(context, 2),
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimens.extraLargePadding),
                      const Expanded(
                        flex: 4,
                        child: _HeroDashboard(isWide: true),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HomeIntro(
                        mutedColor: scheme.onSurfaceVariant,
                        onViewProjects: () => _jumpTo(context, 2),
                      ),
                      const SizedBox(height: Dimens.extraLargePadding),
                      const _HeroDashboard(isWide: false),
                    ],
                  ),
                const SizedBox(height: Dimens.extraLargePadding),
                const _DesignLensStrip(),
                const SizedBox(height: Dimens.extraLargePadding),
                const _ContactStrip(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _jumpTo(final BuildContext context, final int index) {
    final state = context.findAncestorStateOfType<_HomeScreenState>();
    state?._selectSection(index);
  }
}

class _HomeIntro extends StatelessWidget {
  const _HomeIntro({
    required this.mutedColor,
    required this.onViewProjects,
  });

  final Color mutedColor;
  final VoidCallback onViewProjects;

  @override
  Widget build(final BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.home_screen.myName,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: compact ? 46 : 76,
                fontWeight: FontWeight.w900,
                height: 0.96,
              ),
        ),
        const SizedBox(height: Dimens.largePadding),
        Text(
          'Flutter Mobile Developer building cross-platform iOS and Android apps with Clean Architecture, Firebase, REST APIs, native modules, CI/CD, and store release workflows.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: mutedColor,
                height: 1.24,
              ),
        ),
        const SizedBox(height: Dimens.extraLargePadding),
        Wrap(
          spacing: Dimens.mediumPadding,
          runSpacing: Dimens.mediumPadding,
          children: [
            _ActionButton(
              label: 'View resume',
              icon: Icons.arrow_forward_rounded,
              onTap: onViewProjects,
            ),
            _ActionButton(
              label: 'Contact',
              icon: Icons.mail_rounded,
              secondary: true,
              onTap: () => _launchMail(),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroDashboard extends StatelessWidget {
  const _HeroDashboard({required this.isWide});

  final bool isWide;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool twoColumns = isWide || MediaQuery.sizeOf(context).width > 520;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isWide ? 430 : 620),
      child: Column(
        children: [
          _BentoSpotlightCard(
            icon: Icons.draw_rounded,
            title: 'Currently shipping',
            value: 'BoursePad',
            description:
                'Production scholarship-matching app maintained for scalability, accessibility, performance, Firebase-backed data, CI/CD, and App Store / Google Play releases.',
          ),
          const SizedBox(height: Dimens.padding),
          if (twoColumns)
            Row(
              children: const [
                Expanded(
                  child: _BentoMetricCard(
                    value: '6+',
                    label: 'Years mobile dev',
                    icon: Icons.timeline_rounded,
                  ),
                ),
                SizedBox(width: Dimens.mediumPadding),
                Expanded(
                  child: _BentoMetricCard(
                    value: '35+',
                    label: 'Android API target',
                    icon: Icons.android_rounded,
                  ),
                ),
              ],
            )
          else
            const Column(
              children: [
                _BentoMetricCard(
                  value: '6+',
                  label: 'Years mobile dev',
                  icon: Icons.timeline_rounded,
                ),
                SizedBox(height: Dimens.padding),
                _BentoMetricCard(
                  value: '35+',
                  label: 'Android API target',
                  icon: Icons.android_rounded,
                ),
              ],
            ),
          const SizedBox(height: Dimens.padding),
          _BentoStackCard(
            title: 'Core stack',
            chips: const [
              'Flutter',
              'Clean Architecture',
              'Riverpod',
              'Firebase',
              'GitHub Actions',
              'Store release',
            ],
            accent: scheme.primary,
          ),
          const SizedBox(height: Dimens.padding),
          if (twoColumns)
            Row(
              children: [
                Expanded(
                  child: _BentoSmallCard(
                    icon: Icons.check_circle_rounded,
                    title: 'Store releases',
                    text: 'TestFlight, code signing, App Store, Google Play',
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: Dimens.mediumPadding),
                Expanded(
                  child: _BentoSmallCard(
                    icon: Icons.bluetooth_connected_rounded,
                    title: 'Native range',
                    text: 'Kotlin, Swift, BLE, Platform Channels, lifecycle',
                    color: AppColors.secondColor,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _BentoSmallCard(
                  icon: Icons.check_circle_rounded,
                  title: 'Store releases',
                  text: 'TestFlight, code signing, App Store, Google Play',
                  color: scheme.primary,
                ),
                const SizedBox(height: Dimens.padding),
                _BentoSmallCard(
                  icon: Icons.bluetooth_connected_rounded,
                  title: 'Native range',
                  text: 'Kotlin, Swift, BLE, Platform Channels, lifecycle',
                  color: AppColors.secondColor,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DesignLensStrip extends StatelessWidget {
  const _DesignLensStrip();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<_DesignLens> lenses = [
      const _DesignLens(
        'UX flows',
        'Clear journeys from first tap to released feature.',
        Icons.route_rounded,
      ),
      const _DesignLens(
        'Visual systems',
        'Reusable spacing, type, color, and component rules.',
        Icons.dashboard_customize_rounded,
      ),
      const _DesignLens(
        'Responsive craft',
        'Independent sizing for phone, tablet, desktop, and web.',
        Icons.devices_rounded,
      ),
      const _DesignLens(
        'Product polish',
        'Empty, loading, error, accessibility, and release states.',
        Icons.auto_awesome_rounded,
      ),
    ];

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

  final _DesignLens lens;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(lens.icon, color: scheme.primary, size: 24),
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

class _BentoSpotlightCard extends StatelessWidget {
  const _BentoSpotlightCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String value;
  final String description;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconFrame(icon: icon, color: scheme.primary),
              const SizedBox(width: Dimens.mediumPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.largePadding),
          Text(
            description,
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _BentoMetricCard extends StatelessWidget {
  const _BentoMetricCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _BentoCard(
      minHeight: 112,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: scheme.primary),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
          ),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoStackCard extends StatelessWidget {
  const _BentoStackCard({
    required this.title,
    required this.chips,
    required this.accent,
  });

  final String title;
  final List<String> chips;
  final Color accent;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_rounded, color: accent),
              const SizedBox(width: Dimens.padding),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.largePadding),
          Wrap(
            spacing: Dimens.padding,
            runSpacing: Dimens.padding,
            children: [
              for (final String chip in chips)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.mediumPadding,
                      vertical: Dimens.padding,
                    ),
                    child: Text(
                      chip,
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BentoSmallCard extends StatelessWidget {
  const _BentoSmallCard({
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

    return _BentoCard(
      minHeight: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconFrame(icon: icon, color: color),
          const SizedBox(height: Dimens.largePadding),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: Dimens.smallPadding),
          Text(
            text,
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.38),
          ),
        ],
      ),
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

class _BentoCard extends StatelessWidget {
  const _BentoCard({required this.child, this.minHeight});

  final Widget child;
  final double? minHeight;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: const EdgeInsets.all(Dimens.largePadding),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(
          alpha: checkDarkMode(context) ? 0.78 : 0.9,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.38),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: checkDarkMode(context) ? 0.18 : 0.06,
            ),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 900;
    const String summary =
        'Flutter Mobile Developer with 6+ years of experience designing, building, and maintaining cross-platform mobile applications for iOS and Android. Strong background in Flutter, Dart, Clean Architecture, Firebase, REST API integration, native Kotlin/Swift modules, CI/CD automation, and App Store / Google Play release workflows. Experienced across scholarship technology, retail POS, IoT, fitness, and enterprise applications, with the ability to translate business logic and client requirements into scalable, maintainable mobile solutions.';

    return _SectionScaffold(
      eyebrow: 'Profile',
      title:
          'Flutter Mobile Developer shipping scalable, maintainable iOS and Android apps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _AboutSummary(summary: summary)),
                const SizedBox(width: Dimens.extraLargePadding),
                const Expanded(flex: 4, child: _InfoPanel()),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutSummary(summary: summary),
                const SizedBox(height: Dimens.largePadding),
                const _InfoPanel(),
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
  const _InfoPanel();

  @override
  Widget build(final BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _InfoRow(t.home_screen.website, 'samchancanada1.github.io/portfolio'),
          _InfoRow(t.home_screen.phone, '+1 (437) 662-8303'),
          _InfoRow(t.home_screen.city, t.home_screen.myCity),
          _InfoRow(t.home_screen.degree, t.home_screen.myDegree),
          _InfoRow(t.home_screen.email, 'samchancanada1@gmail.com'),
          _InfoRow(t.home_screen.freelance, t.home_screen.available),
          const _InfoRow('Work', 'Authorized to work in Canada'),
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
    final List<_Stat> stats = [
      const _Stat('6+', 'Years mobile development', Icons.timeline_rounded),
      const _Stat('2', 'Live store releases', Icons.rocket_launch_rounded),
      const _Stat('5', 'Product domains', Icons.dashboard_customize_rounded),
      const _Stat('35+', 'Android API target', Icons.android_rounded),
    ];

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
            childAspectRatio: columns == 4 ? 1.35 : 1.1,
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

  final _Stat stat;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(stat.icon, color: scheme.primary),
          Text(
            stat.value,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            stat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: scheme.onSurfaceVariant),
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
    return _SectionScaffold(
      eyebrow: 'Experience',
      title: 'Production roles shaped with product craft and mobile depth',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CoreCompetenciesCard(),
          const SizedBox(height: Dimens.extraLargePadding),
          for (final _Experience experience in _experiences)
            Padding(
              padding: const EdgeInsets.only(bottom: Dimens.largePadding),
              child: _ExperienceCard(experience: experience),
            ),
        ],
      ),
    );
  }
}

class _CoreCompetenciesCard extends StatelessWidget {
  const _CoreCompetenciesCard();

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 820;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow('Core competencies'),
          const SizedBox(height: Dimens.mediumPadding),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 5, child: _CoreCompetenciesIntro()),
                const SizedBox(width: Dimens.extraLargePadding),
                Expanded(
                  flex: 4,
                  child: _ImpactGrid(accent: scheme.primary),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CoreCompetenciesIntro(),
                const SizedBox(height: Dimens.largePadding),
                _ImpactGrid(accent: scheme.primary),
              ],
            ),
        ],
      ),
    );
  }
}

class _CoreCompetenciesIntro extends StatelessWidget {
  const _CoreCompetenciesIntro();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cross-platform Flutter, architecture, release, APIs, offline-first, and BLE',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                height: 1.02,
              ),
        ),
        const SizedBox(height: Dimens.padding),
        Text(
          'Core competencies from the resume',
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: Dimens.largePadding),
        Text(
          'Focused on cross-platform Flutter development, mobile app architecture, App Store / Google Play release management, REST API and third-party SDK integration, offline-first apps, Bluetooth / IoT integration, and translating business logic into maintainable mobile workflows.',
          style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: Dimens.largePadding),
        Wrap(
          spacing: Dimens.padding,
          runSpacing: Dimens.padding,
          children: const [
            _MiniBadge('Cross-platform Flutter'),
            _MiniBadge('Clean Architecture'),
            _MiniBadge('REST API integration'),
            _MiniBadge('Offline-first'),
            _MiniBadge('Bluetooth / IoT'),
            _MiniBadge('Business logic'),
          ],
        ),
      ],
    );
  }
}

class _ImpactGrid extends StatelessWidget {
  const _ImpactGrid({required this.accent});

  final Color accent;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final bool wide = constraints.maxWidth > 360;
        final List<Widget> cards = [
          _ImpactCard(
            icon: Icons.phone_iphone_rounded,
            title: 'Mobile',
            text: 'Flutter, Dart, Android, iOS, Kotlin, Swift',
            color: accent,
          ),
          _ImpactCard(
            icon: Icons.api_rounded,
            title: 'APIs',
            text: 'Firebase Auth, Firestore, FCM, Analytics, REST APIs',
            color: accent,
          ),
          _ImpactCard(
            icon: Icons.account_tree_rounded,
            title: 'Architecture',
            text: 'Clean Architecture, Riverpod, GoRouter, Firebase',
            color: accent,
          ),
          _ImpactCard(
            icon: Icons.storefront_rounded,
            title: 'Release',
            text: 'Xcode 16, Android API 35+, App Store, Google Play',
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

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});

  final _Experience experience;

  @override
  Widget build(final BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 760;

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: _ExperienceHeader(experience: experience),
                ),
                const SizedBox(width: Dimens.extraLargePadding),
                Expanded(child: _ExperienceDetails(experience: experience)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ExperienceHeader(experience: experience),
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
                for (final _ResumeLink link in experience.links)
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
  const _ExperienceHeader({required this.experience});

  final _Experience experience;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniBadge(experience.period),
        const SizedBox(height: Dimens.mediumPadding),
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

class _ExperienceDetails extends StatelessWidget {
  const _ExperienceDetails({required this.experience});

  final _Experience experience;

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.role,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: Dimens.mediumPadding),
        for (final String point in experience.points)
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: scheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: Dimens.padding),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      height: 1.48,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

class _SkillsView extends StatelessWidget {
  const _SkillsView();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const List<_CapabilityGroup> capabilityGroups = [
      _CapabilityGroup(
        title: 'Mobile',
        description:
            'Cross-platform mobile development for Android, iOS, and web using Flutter and Dart, with native Kotlin and Swift modules when platform capabilities are needed.',
        icon: Icons.phone_iphone_rounded,
        skills: ['Flutter', 'Dart', 'Android', 'iOS', 'Kotlin', 'Swift'],
      ),
      _CapabilityGroup(
        title: 'Architecture',
        description:
            'Maintainable Flutter app structures with Clean Architecture, modular service layers, dependency injection, and practical state management.',
        icon: Icons.account_tree_rounded,
        skills: ['Clean Architecture', 'BLoC', 'Riverpod', 'Provider', 'GetIt'],
      ),
      _CapabilityGroup(
        title: 'Backend and APIs',
        description:
            'Firebase-backed app features and API integrations for authentication, real-time data, notifications, analytics, and business workflows.',
        icon: Icons.cloud_done_rounded,
        skills: [
          'Firebase Auth',
          'Firestore',
          'Cloud Messaging',
          'Analytics',
          'REST APIs',
          '.NET APIs',
          'Spring APIs',
        ],
      ),
      _CapabilityGroup(
        title: 'CI/CD and release',
        description:
            'Release workflows covering automated builds, testing, signing, TestFlight, App Store, Google Play, Docker, and GitHub Actions.',
        icon: Icons.rocket_launch_rounded,
        skills: [
          'Git',
          'GitHub Actions',
          'Docker',
          'TestFlight',
          'App Store',
          'Google Play',
          'Code Signing',
        ],
      ),
      _CapabilityGroup(
        title: 'Mobile features',
        description:
            'Practical app features that support production mobile behavior, device connectivity, offline use, deep linking, lifecycle handling, and notifications.',
        icon: Icons.hub_rounded,
        skills: [
          'Push Notifications',
          'Deep Linking',
          'Platform Channels',
          'App Lifecycle',
          'Offline-first',
          'BLE',
          'SQLite',
          'Hive',
        ],
      ),
      _CapabilityGroup(
        title: 'Testing and other',
        description:
            'Testing, backend proof-of-concept, search, and tooling experience from production work and the AI Resume Parser project.',
        icon: Icons.fact_check_rounded,
        skills: [
          'flutter_test',
          'mockito',
          'integration_test',
          'Python',
          'C#',
          'FastAPI',
          'Elasticsearch',
          'Unity',
        ],
      ),
    ];
    const List<String> allSkills = [
      'Flutter (Android, iOS, Web)',
      'Dart',
      'Clean Architecture',
      'BLoC',
      'Riverpod',
      'Provider',
      'GetIt',
      'GoRouter',
      'Firebase Auth',
      'Firestore',
      'Firebase Cloud Messaging',
      'Firebase Analytics',
      'REST APIs',
      '.NET APIs',
      'Spring APIs',
      'GitHub Actions',
      'Docker',
      'TestFlight',
      'App Store',
      'Google Play',
      'Code Signing',
      'Platform Channels',
      'Deep Linking',
      'App Lifecycle',
      'Push Notifications',
      'Offline-first',
      'BLE',
      'SQLite',
      'Hive',
      'Kotlin',
      'Swift',
      'Git and GitHub',
      'flutter_test',
      'mockito',
      'integration_test',
      'Python',
      'C#',
      'FastAPI',
      'Elasticsearch',
      'Unity',
    ];

    return _SectionScaffold(
      eyebrow: 'Capabilities',
      title: 'Technical skills from the updated resume',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Text(
              'Grouped around the resume categories: mobile development, architecture, backend and APIs, CI/CD and release, mobile features, testing, and additional tooling.',
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
                  for (final _CapabilityGroup group in capabilityGroups)
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
            'Detailed toolbox',
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

  final _CapabilityGroup group;

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
              _IconFrame(icon: group.icon, color: scheme.primary),
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
  const _ContactStrip({this.compact = false});

  final bool compact;

  @override
  Widget build(final BuildContext context) {
    final List<_ContactAction> actions = [
      _ContactAction(
        'LinkedIn',
        Icons.business_center_rounded,
        'https://www.linkedin.com/in/hiu-tung-chan-051b61231/',
      ),
      _ContactAction(
        'GitHub',
        Icons.code_rounded,
        'https://github.com/samchancanada1',
      ),
      _ContactAction(
        'Stack Overflow',
        Icons.question_answer_rounded,
        'https://stackoverflow.com/users/14233004/sam-chan',
      ),
      _ContactAction(
        'WhatsApp',
        Icons.chat_rounded,
        'https://wa.me/+14376628303',
      ),
      _ContactAction(
        'Email',
        Icons.mail_rounded,
        'mailto:samchancanada1@gmail.com?subject=We%20are%20interested%20in%20you!',
      ),
    ];

    return Wrap(
      spacing: Dimens.padding,
      runSpacing: Dimens.padding,
      children: [
        for (final _ContactAction action in actions)
          compact
              ? IconButton.filledTonal(
                  tooltip: action.label,
                  onPressed: () => _launch(action.url),
                  icon: Icon(action.icon),
                )
              : _SocialButton(action: action),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.action});

  final _ContactAction action;

  @override
  Widget build(final BuildContext context) {
    return ActionChip(
      avatar: Icon(action.icon, size: 18),
      label: Text(action.label),
      onPressed: () => _launch(action.url),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.secondary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool secondary;

  @override
  Widget build(final BuildContext context) {
    return secondary
        ? OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Text(label),
          )
        : FilledButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Text(label),
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
          alpha: checkDarkMode(context) ? 0.72 : 0.84,
        ),
        borderRadius: BorderRadius.circular(Dimens.corners),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.34),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: checkDarkMode(context) ? 0.18 : 0.07,
            ),
            blurRadius: 28,
            offset: const Offset(0, 16),
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

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _Experience {
  const _Experience({
    required this.company,
    required this.role,
    required this.location,
    required this.period,
    required this.points,
    required this.tech,
    this.links = const [],
  });

  final String company;
  final String role;
  final String location;
  final String period;
  final List<String> points;
  final List<String> tech;
  final List<_ResumeLink> links;
}

class _ResumeLink {
  const _ResumeLink(this.label, this.url);

  final String label;
  final String url;
}

class _DesignLens {
  const _DesignLens(this.title, this.description, this.icon);

  final String title;
  final String description;
  final IconData icon;
}

class _CapabilityGroup {
  const _CapabilityGroup({
    required this.title,
    required this.description,
    required this.icon,
    required this.skills,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> skills;
}

class _Stat {
  const _Stat(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;
}

class _ContactAction {
  const _ContactAction(this.label, this.icon, this.url);

  final String label;
  final IconData icon;
  final String url;
}

final List<_Experience> _experiences = [
  _Experience(
    company: 'BoursePad',
    role: 'Flutter Developer',
    location: 'Remote / Toronto',
    period: 'Jun 2025 - Present',
    points: const [
      'Enhanced and maintained a production Flutter scholarship-matching application with a focus on scalability, accessibility, performance, and long-term maintainability.',
      'Applied Clean Architecture with Riverpod, GoRouter, GetIt, and modular feature-based structure to improve separation, testability, and maintainability.',
      'Upgraded the app for Xcode 16 and Android API 35+ requirements, keeping releases aligned with current App Store and Google Play standards.',
      'Integrated Firebase Auth, Firestore, Cloud Messaging, and Analytics for authentication, real-time data, notifications, communication, and product insights.',
      'Built CI/CD pipelines from scratch using GitHub Actions for automated build, test, deployment, multi-environment release workflows, and regression risk reduction.',
      'Managed App Store and Google Play release workflows including provisioning profiles, code signing, release builds, version control, and store submission requirements.',
      'Implemented cross-platform mobile features including App Lifecycle handling, Platform Channels, deep linking, and native integration for reliable iOS and Android behavior.',
    ],
    tech: const [
      'Flutter',
      'Clean Architecture',
      'Riverpod',
      'GoRouter',
      'GetIt',
      'Firebase',
      'GitHub Actions',
      'App Store',
      'Google Play',
    ],
    links: const [
      _ResumeLink(
        'App Store',
        'https://apps.apple.com/us/app/boursepad/id6738283933',
      ),
      _ResumeLink(
        'Google Play',
        'https://play.google.com/store/apps/details?id=com.eruditio.boursepad',
      ),
    ],
  ),
  _Experience(
    company: 'KeelWorks Foundation',
    role: 'Mobile Developer',
    location: 'Remote',
    period: 'Jan 2025 - Jun 2025',
    points: const [
      'Developed a Flutter mobile application for real-time water usage tracking and conservation insights.',
      'Structured core modules with BLoC to separate business logic from UI and improve maintainability.',
      'Integrated secure REST APIs with backend services for reliable user-specific usage records.',
      'Built interactive charts and dashboard components to present consumption trends clearly on mobile.',
      'Improved onboarding, navigation, and UI flows for a smoother cross-platform user experience.',
    ],
    tech: const ['Flutter', 'BLoC', 'REST APIs', 'Charts', 'Mobile UX'],
  ),
  _Experience(
    company: 'Independent Flutter Developer',
    role: 'Flutter Developer',
    location: 'Remote / Part-time Contract',
    period: 'May 2022 - Present',
    points: const [
      'Built early-stage Flutter apps and internal tools for clients across retail, IoT, and fitness domains.',
      'Worked directly with clients to clarify business logic and translate operational needs into practical mobile workflows.',
      'Designed scalable Flutter structures with Dart, BLoC/Provider, reusable UI components, and modular service layers.',
      'Made architecture and implementation decisions by balancing performance, development timeline, budget constraints, and long-term maintainability.',
      'Integrated REST APIs, push notifications, authentication flows, and third-party SDKs for MVP and internal-use app requirements.',
      'Developed platform-specific Kotlin and Swift modules for native device capabilities including sensors, Bluetooth communication, and background behavior.',
      'Implemented Bluetooth Low Energy and offline-first functionality with SQLite and Hive for reliability under network and device constraints.',
    ],
    tech: const [
      'Flutter',
      'BLoC',
      'Provider',
      'Kotlin',
      'Swift',
      'BLE',
      'SQLite',
      'Hive',
    ],
  ),
  _Experience(
    company: 'Computer And Technologies Holdings',
    role: 'Developer',
    location: 'Hong Kong',
    period: 'Sep 2019 - May 2022',
    points: const [
      'Contributed to migrating a legacy POS system into a mobile-first Flutter solution for COACH Asia retail operations.',
      'Worked with business and technical stakeholders to understand retail transaction logic, inventory workflows, payment scenarios, and operational requirements.',
      'Integrated Flutter apps with a .NET backend and REST APIs for order processing, inventory updates, and retail workflow synchronization.',
      'Designed modular UI components and service layers to improve maintainability, reduce repeated implementation effort, and support future feature expansion.',
      'Implemented deep linking and Alipay payment integration to support smoother and more secure transaction flows.',
      'Integrated BLE communication for portable barcode scanners and thermal printers.',
      'Supported multilingual Chinese and English retail workflows, code reviews, debugging, and production stability improvements.',
    ],
    tech: const ['Flutter', '.NET APIs', 'REST APIs', 'Alipay', 'BLE'],
    links: const [
      _ResumeLink(
        'Coach Asia POS',
        'https://www.chainstoreplus.com/en/products/mpos',
      ),
    ],
  ),
  _Experience(
    company: 'AI Resume Parser',
    role: 'Additional Project',
    location: 'Proof of concept',
    period: 'Project',
    points: const [
      'Built a proof-of-concept AI-powered resume screening backend with FastAPI REST APIs.',
      'Implemented Elasticsearch search and retrieval, contextual skill matching, custom scoring workflows, and Dockerized development/deployment support.',
    ],
    tech: const ['Python', 'spaCy', 'FastAPI', 'Docker', 'Elasticsearch'],
  ),
];

double _contentInset(final BuildContext context) {
  final double width = MediaQuery.sizeOf(context).width;
  if (width >= 1200) {
    return Dimens.extraLargePadding * 2;
  }
  if (width >= 700) {
    return Dimens.extraLargePadding;
  }
  return Dimens.largePadding;
}

Future<void> _launchMail() async {
  await _launch(
    'mailto:samchancanada1@gmail.com?subject=We%20are%20interested%20in%20you!',
  );
}

Future<void> _launch(final String value) async {
  await launchUrl(Uri.parse(value));
}
