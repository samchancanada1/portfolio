import 'package:flutter/material.dart';

import '../../domain/entities/home_icon_key.dart';

extension HomeIconMapper on HomeIconKey {
  IconData get icon {
    switch (this) {
      case HomeIconKey.route:
        return Icons.route_rounded;
      case HomeIconKey.dashboardCustomize:
        return Icons.dashboard_customize_rounded;
      case HomeIconKey.devices:
        return Icons.devices_rounded;
      case HomeIconKey.autoAwesome:
        return Icons.auto_awesome_rounded;
      case HomeIconKey.timeline:
        return Icons.timeline_rounded;
      case HomeIconKey.rocketLaunch:
        return Icons.rocket_launch_rounded;
      case HomeIconKey.android:
        return Icons.android_rounded;
      case HomeIconKey.phone:
        return Icons.phone_iphone_rounded;
      case HomeIconKey.accountTree:
        return Icons.account_tree_rounded;
      case HomeIconKey.cloudDone:
        return Icons.cloud_done_rounded;
      case HomeIconKey.hub:
        return Icons.hub_rounded;
      case HomeIconKey.factCheck:
        return Icons.fact_check_rounded;
      case HomeIconKey.businessCenter:
        return Icons.business_center_rounded;
      case HomeIconKey.code:
        return Icons.code_rounded;
      case HomeIconKey.questionAnswer:
        return Icons.question_answer_rounded;
      case HomeIconKey.chat:
        return Icons.chat_rounded;
      case HomeIconKey.mail:
        return Icons.mail_rounded;
    }
  }
}
