import 'package:flutter/material.dart';

import '../../../../core/utils/sized_context.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_desktop_size.dart';
import '../../../../core/utils/get_primary_color.dart';
import '../../../../core/utils/locale_handler.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/app_svg_viewer.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class StatisticsItems extends StatelessWidget {
  const StatisticsItems({super.key});

  @override
  Widget build(final BuildContext context) {
    return ResponsiveLayout(
      children: [
        StatsItem(
          title: t.home_screen.happyClients,
          stat: '8',
          iconPath: Assets.icons.users,
        ),
        if (!checkDesktopSize(context)) const Divider(),
        StatsItem(
          title: t.home_screen.projects,
          stat: '13',
          iconPath: Assets.icons.projectsList,
        ),
        if (!checkDesktopSize(context)) const Divider(),
        StatsItem(
          title: t.home_screen.trainedStudent,
          stat: '2',
          iconPath: Assets.icons.users,
        ),
        if (!checkDesktopSize(context)) const Divider(),
        StatsItem(
          title: t.home_screen.hoursOfSupport,
          stat: checkEnState(context) ? '+300' : '300+',
          iconPath: Assets.icons.cloack,
        ),
      ],
    );
  }
}

class StatsItem extends StatelessWidget {
  const StatsItem({
    super.key,
    required this.title,
    required this.stat,
    required this.iconPath,
  });

  final String title;
  final String stat;
  final String iconPath;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: checkSmallDeviceSize(context) ? context.widthPx : null,
      padding: const EdgeInsets.all(Dimens.largePadding),
      child: checkDesktopSize(context)
          ? Column(
              children: [
                AppSvgViewer(
                  path: iconPath,
                  size: 50,
                  setDefaultColor: false,
                  color: getPrimaryColor(context),
                ),
                const AppVSpace(),
                Text(
                  stat,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                const AppVSpace(
                  space: Dimens.padding,
                ),
                Text(
                  title,
                ),
              ],
            )
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppSvgViewer(
                path: iconPath,
                size: 50,
                setDefaultColor: false,
                color: getPrimaryColor(context),
              ),
              title: Text(
                stat,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  height: 0,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.padding,
                ),
                child: Text(
                  title,
                ),
              ),
            ),
    );
  }
}
