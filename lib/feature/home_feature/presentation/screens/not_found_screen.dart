import 'package:flutter/material.dart';
import 'package:portfolio/core/widgets/typography/app_title_text.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/lottie_viewer.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';


class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      smallBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieViewer(
              path: Assets.animations.notFound,
              width: 200.0,
              height: 200.0,
            ),
            const AppVSpace(space: Dimens.largePadding),
            AppTitleText(t.notFound),
          ],
        ),
      ),
    );
  }
}
