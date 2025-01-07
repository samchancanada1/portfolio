import 'package:flutter/material.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../gen/assets.gen.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.size, this.radius});

  final double size;
  final double? radius;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          radius ?? Dimens.corners,
        ),
        child: Image.asset(
          Assets.images.profileImage.path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
