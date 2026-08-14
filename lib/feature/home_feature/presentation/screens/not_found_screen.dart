import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.animations.notFound,
              width: 200.0,
              height: 200.0,
            ),
            const SizedBox(height: Dimens.largePadding),
            Text(
              t.notFound,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
