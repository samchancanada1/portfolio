import 'package:flutter/material.dart';

import '../../../../core/utils/sized_context.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_desktop_size.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/general_appbar.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/typography/app_title_text.dart';
import '../../../../i18n/strings.g.dart';
import 'about_item.dart';
import 'profile_image.dart';
import 'statistics_items.dart';

class AboutSectionWidget extends StatelessWidget {
  const AboutSectionWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(
        title: t.home_screen.about,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.largePadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!checkDesktopSize(context))
                ProfileImage(size: context.widthPx),
              const AppVSpace(),
              AppTitleText(
                t.home_screen.aboutTitle,
              ),
              const AppVSpace(),
              Text(
                t.home_screen.aboutMeDescription,
                textAlign: TextAlign.justify,
              ),
              const AppVSpace(),
              ResponsiveLayout(
                crossAxisAlignment: checkDesktopSize(context)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (checkDesktopSize(context))
                    const ProfileImage(size: 150.0),
                  if (checkDesktopSize(context))
                    const AppHSpace()
                  else
                    const AppVSpace(),
                  if (checkDesktopSize(context))
                    const Expanded(
                      child: AboutItems(),
                    )
                  else
                    const AboutItems(),
                ],
              ),
              const AppVSpace(
                space: Dimens.extraLargePadding,
              ),
              AppTitleText(
                t.home_screen.statistics,
              ),
              const StatisticsItems(),
              const AppVSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
