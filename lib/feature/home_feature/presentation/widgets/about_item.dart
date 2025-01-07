import 'package:flutter/material.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/get_primary_color.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../i18n/strings.g.dart';

class AboutItems extends StatelessWidget {
  const AboutItems({super.key});

  @override
  Widget build(final BuildContext context) {
    return ResponsiveLayout(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      rowWithExpanded: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AboutItem(
              title: t.home_screen.website,
              value: 'linkedin.com/in/hiu-tung-chan-051b61231/',
              showAll: true,
            ),
            AboutItem(
              title: t.home_screen.phone,
              value: '+1 (437)662-8303',
            ),
            AboutItem(
              title: t.home_screen.city,
              value: t.home_screen.myCity,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AboutItem(
              title: t.home_screen.degree,
              value: t.home_screen.myDegree,
              showAll: true,
            ),
            AboutItem(
              title: t.home_screen.email,
              value: 'samchancanada1@gmail.com',
              showAll: true,
            ),
            AboutItem(
              title: t.home_screen.freelance,
              value: t.home_screen.available,
            ),
          ],
        ),
      ],
    );
  }
}

class AboutItem extends StatelessWidget {
  const AboutItem(
      {super.key,
      required this.title,
      required this.value,
      this.showAll = false});

  final String title;
  final String value;
  final bool showAll;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.padding),
      child: Row(
        children: [
          Icon(
            Icons.chevron_right,
            size: 24,
            color: getPrimaryColor(context),
          ),
          const AppHSpace(),
          Text(
            '$title:  ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: Tooltip(
            message: showAll ? value : "",
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
      ),
    );
  }
}
