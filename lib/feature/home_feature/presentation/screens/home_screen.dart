import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_desktop_size.dart';
import '../../../../core/utils/check_theme_status.dart';
import '../../../../core/utils/get_primary_color.dart';
import '../../../../core/utils/sized_context.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/app_svg_viewer.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/about_section_widget.dart';
// import '../widgets/contact_section_widget.dart';
import '../widgets/home_section_widget.dart';
import '../widgets/resume_section_widget.dart';
import '../widgets/settings_section_widget.dart';
import '../widgets/skills_section_widget.dart';
import '../widgets/social_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(final BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavigationBarItems = [
      BottomNavigationBarItem(
        label: t.home_screen.home,
        activeIcon: const Icon(Icons.home),
        icon: const Icon(Icons.home_outlined),
      ),
      BottomNavigationBarItem(
        label: t.home_screen.about,
        activeIcon: const Icon(Icons.person),
        icon: const Icon(Icons.person_outline),
      ),
      BottomNavigationBarItem(
        label: t.home_screen.resume,
        activeIcon: const Icon(Icons.contact_page),
        icon: const Icon(Icons.contact_page_outlined),
      ),
      BottomNavigationBarItem(
        label: t.home_screen.skills,
        activeIcon: const Icon(Icons.design_services),
        icon: const Icon(Icons.design_services_outlined),
      ),
      // BottomNavigationBarItem(
      //   label: t.home_screen.contact,
      //   activeIcon: const Icon(Icons.mail),
      //   icon: const Icon(Icons.mail_outlined),
      // ),
      BottomNavigationBarItem(
        label: t.home_screen.settings,
        activeIcon: const Icon(Icons.settings),
        icon: const Icon(Icons.settings_outlined),
      ),
    ];

    final List<AppNavigationDestination> destinations = [
      AppNavigationDestination(
        label: t.home_screen.home,
        selectedIcon: const Icon(Icons.home),
        icon: const Icon(Icons.home_outlined),
      ),
      AppNavigationDestination(
        label: t.home_screen.about,
        selectedIcon: const Icon(Icons.person),
        icon: const Icon(Icons.person_outline),
      ),
      AppNavigationDestination(
        label: t.home_screen.resume,
        selectedIcon: const Icon(Icons.contact_page),
        icon: const Icon(Icons.contact_page_outlined),
      ),
      AppNavigationDestination(
        label: t.home_screen.skills,
        selectedIcon: const Icon(Icons.design_services),
        icon: const Icon(Icons.design_services_outlined),
      ),
      // AppNavigationDestination(
      //   label: t.home_screen.contact,
      //   selectedIcon: const Icon(Icons.mail),
      //   icon: const Icon(Icons.mail_outlined),
      // ),
      AppNavigationDestination(
        label: t.home_screen.settings,
        selectedIcon: const Icon(Icons.settings),
        icon: const Icon(Icons.settings_outlined),
      ),
    ];
    final List<Widget> sections = [
      const HomeSectionWidget(),
      const AboutSectionWidget(),
      const ResumeSectionWidget(),
      const SkillsSectionWidget(),
      // const ContactSectionWidget(),
      const SettingsSectionWidget(),
    ];
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: PageTransitionSwitcher(
        transitionBuilder: (
          final Widget child,
          final Animation<double> animation,
          final Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          );
        },
        child: sections[selectedIndex],
      ),
      secondaryBody: !checkDesktopSize(context)
          ? null
          : SizedBox(
              height: context.heightPx,
              child: NavigationDrawer(
                selectedIndex: selectedIndex,
                onDestinationSelected: (final index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [
                  const AppVSpace(
                    space: Dimens.largePadding,
                  ),
                  Column(
                    children: [
                      AppSvgViewer(
                        path: Assets.images.tungLogo,
                        size: 130.0,
                        setDefaultColor: false,
                      ),
                      const AppVSpace(),
                      Text(
                        t.home_screen.myName,
                        style: TextStyle(
                          color: getPrimaryColor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const AppVSpace(
                    space: Dimens.largePadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon(
                        message: "Linkedin",
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'https://www.linkedin.com/in/hiu-tung-chan-051b61231/'));
                        },
                        imageUrl: Assets.icons.linkedinIcon.path,
                      ),
                      SocialIcon(
                        message: "Github",
                        onTap: () async {
                          await launchUrl(
                              Uri.parse('https://github.com/samchancanada1'));
                        },
                        imageUrl: Assets.icons.githubLogo.path,
                      ),
                      SocialIcon(
                        message: "Stackoverflow",
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              'https://stackoverflow.com/users/14233004/sam-chan'));
                        },
                        imageUrl: Assets.icons.stackoverflowIcon.path,
                      ),
                      SocialIcon(
                        message: "Whatsapp",
                        onTap: () async {
                          await launchUrl(
                              Uri.parse('https://wa.me/+14376628303'));
                        },
                        imageUrl: Assets.icons.whatsappLogo.path,
                      ),
                      SocialIcon(
                        message: "Email me",
                        onTap: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'samchancanada1@gmail.com.com',
                            query: encodeQueryParameters(<String, String>{
                              'subject': 'We are interested in you!',
                            }),
                          );

                          await launchUrl(emailLaunchUri);
                        },
                        imageUrl: Assets.icons.emailIcon.path,
                      ),
                    ],
                  ),
                  const AppVSpace(),
                  const AppDivider(),
                  const AppVSpace(),
                  ...destinations.map(
                    (final AppNavigationDestination destination) {
                      return NavigationDrawerDestination(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.padding,
                          ),
                          child: Text(destination.label),
                        ),
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                      );
                    },
                  ),
                  const AppVSpace(),
                ],
              ),
            ),
      bottomNavigationBar: checkDesktopSize(context)
          ? null
          : BottomNavigationBar(
              items: bottomNavigationBarItems,
              currentIndex: selectedIndex,
              selectedItemColor: getPrimaryColor(context),
              unselectedItemColor:
                  checkDarkMode(context) ? Colors.white : Colors.black54,
              onTap: (final index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
    );
  }
}
