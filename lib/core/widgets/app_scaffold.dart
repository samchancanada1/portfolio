import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/core/widgets/app_drawer.dart';

import '../theme/dimens.dart';
import '../utils/check_desktop_size.dart';
import 'buttons/app_fab.dart';
import 'general_appbar.dart';
import 'listview/app_list_view.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.secondaryBody,
    this.smallBody,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.bodyFlex = 2,
    this.secondaryBodyFlex = 1,
    this.padding,
  });

  final GeneralAppBar? appBar;
  final AppFab? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final AppDrawer? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final DragStartBehavior drawerDragStartBehavior;
  final Widget? body;
  final Widget? secondaryBody;
  final Widget? smallBody;
  final int bodyFlex;
  final int secondaryBodyFlex;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(final BuildContext context) {
    return SelectionArea(
        child: Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: Dimens.padding,
              ),
          child: smallBody != null
              ? (checkDesktopSize(context)
                  ? Center(
                      child: SizedBox(
                        width: Dimens.mediumDeviceBreakPoint,
                        child: smallBody,
                      ),
                    )
                  : smallBody)
              : checkDesktopSize(context)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (secondaryBody == null)
                          const SizedBox.shrink()
                        else
                          SizedBox(
                            width: 300,
                            child: secondaryBody,
                          ),
                        Expanded(
                          flex: bodyFlex,
                          child: body ?? const SizedBox.shrink(),
                        ),
                      ],
                    )
                  : secondaryBody == null
                      ? body ?? const SizedBox.shrink()
                      : AppListView(
                          shrinkWrap: true,
                          children: [
                            body ?? const SizedBox.shrink(),
                            secondaryBody ?? const SizedBox.shrink(),
                          ],
                        ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(Dimens.padding),
              child: bottomSheet,
            ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawerDragStartBehavior: drawerDragStartBehavior,
    ));
  }
}
