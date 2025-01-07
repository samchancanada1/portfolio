import 'package:flutter/material.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/get_primary_color.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      this.message = ''});

  final GestureTapCallback onTap;
  final String imageUrl;
  final String message;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        Dimens.largePadding,
      ),
      onTap: onTap,
      child: Tooltip(
        message: message,
        child: Container(
          padding: const EdgeInsets.all(Dimens.padding),
          child: Image.asset(
            imageUrl,
            width: 30.0,
            color: getPrimaryColor(context),
          ),
        ),
      ),
    );
  }
}
