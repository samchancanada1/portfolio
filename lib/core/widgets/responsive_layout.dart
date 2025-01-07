import 'package:flutter/material.dart';

import '../utils/check_desktop_size.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.children,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.rowWithExpanded = false,
    this.columnWithExpanded = false,
  });

  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool rowWithExpanded;
  final bool columnWithExpanded;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: checkDesktopSize(context)
          ? Row(
              mainAxisAlignment:
                  mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.start,
              children: (rowWithExpanded)
                  ? children.map((e) => Expanded(child: e)).toList()
                  : children,
            )
          : Column(
              mainAxisAlignment:
                  mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: (columnWithExpanded)
                  ? children.map((e) => Expanded(child: e)).toList()
                  : children,
            ),
    );
  }
}
