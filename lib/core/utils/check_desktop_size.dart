import 'package:flutter/material.dart';
import '../utils/sized_context.dart';
import '../theme/dimens.dart';

bool checkDesktopSize(final BuildContext context) {
  return context.sizePx.width > Dimens.largeDeviceBreakPoint;
}

bool checkMediumDeviceSize(final BuildContext context) {
  return context.sizePx.width > Dimens.mediumDeviceBreakPoint;
}

bool checkSmallDeviceSize(final BuildContext context) {
  return context.widthPx < Dimens.smallDeviceBreakPoint;
}

bool checkVerySmallDeviceSize(final BuildContext context) {
  return context.widthPx < Dimens.verySmallDeviceBreakPoint;
}
