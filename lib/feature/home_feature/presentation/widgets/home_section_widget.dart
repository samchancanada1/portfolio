import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_desktop_size.dart';
import '../../../../core/utils/check_theme_status.dart';
import '../../../../core/utils/get_primary_color.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';
import '/core/utils/sized_context.dart';

class HomeSectionWidget extends StatelessWidget {
  const HomeSectionWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    const int speed = 150;
    return Stack(
      children: [
        Image.asset(
          width: context.widthPx,
          height: context.heightPx,
          checkSmallDeviceSize(context)
              ? Assets.images.smallHomeBg.path
              : Assets.images.homeBackground.path,
          fit: BoxFit.cover,
        ),
        Container(
          width: context.widthPx,
          height: context.heightPx,
          color: checkDarkMode(context)
              ? Colors.black.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.largePadding+55,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 125,
              ),
              Text(
                t.home_screen.myName,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: getPrimaryColor(context),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: Row(
                  children: [
                    Text(
                      t.home_screen.iAm,
                      style: TextStyle(
                        fontSize: 35.0,
                        color: AppColors.white,
                      ),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            t.home_screen.developer,
                            speed: const Duration(milliseconds: speed),
                            textStyle: TextStyle(
                              fontFamily: 'IranYekanXFaNum',
                              color: AppColors.white,
                            ),
                          ),
                          TypewriterAnimatedText(
                            t.home_screen.designer,
                            speed: const Duration(milliseconds: speed),
                            textStyle: TextStyle(
                              fontFamily: 'IranYekanXFaNum',
                              color: AppColors.white,
                            ),
                          ),
                          TypewriterAnimatedText(
                            t.home_screen.freelancer,
                            speed: const Duration(milliseconds: speed),
                            textStyle: TextStyle(
                              fontFamily: 'IranYekanXFaNum',
                              color: checkDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          // TypewriterAnimatedText(
                          //   t.youtuber,
                          //   speed: const Duration(milliseconds: speed),
                          //   textStyle: TextStyle(
                          //     fontFamily: 'IranYekanXFaNum',
                          //     color: AppColors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
