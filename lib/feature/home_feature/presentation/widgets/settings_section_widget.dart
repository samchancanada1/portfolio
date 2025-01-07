import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_theme_status.dart';
import '../../../../core/utils/locale_handler.dart';
import '../../../../core/widgets/app_bottom_sheet_dialog.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';
import '../../../../core/widgets/general_appbar.dart';
import '../../../../i18n/strings.g.dart';
import '../bloc/counter_cubit.dart';
import '../bloc/primary_color_cubit.dart';
import '../bloc/theme_cubit.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(
        title: t.home_screen.settings,
      ),
      smallBody: ListView(
        shrinkWrap: true,
        children: [
          BlocBuilder<CounterCubit, int>(
            builder: (final BuildContext context, final int state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    AppCard(
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t.home_screen.themeMode),
                          Switch(
                            thumbIcon: WidgetStateProperty.resolveWith<Icon>(
                                (final Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return const Icon(Icons.dark_mode_outlined);
                              } else {
                                return const Icon(Icons.light_mode_outlined);
                              }
                            }),
                            value: checkDarkMode(context),
                            onChanged: (final bool value) {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          ),
                        ],
                      ),
                    ),
                    const AppVSpace(),
                    AppCard(
                      onTap: () {
                        changeLanguageDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t.home_screen.language),
                          Row(
                            children: [
                              Text(LocaleHandler().getLocaleTitle(context)),
                              const AppHSpace(),
                              const Icon(Icons.keyboard_arrow_down_sharp),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppVSpace(),
                    AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t.home_screen.themeColor),
                          Row(
                            children: [
                              AppIconButton(
                                icon: Icons.color_lens_outlined,
                                iconColor: Colors.red,
                                onPressed: () {
                                  context
                                      .read<PrimaryColorCubit>()
                                      .setRedColor();
                                },
                              ),
                              const AppHSpace(),
                              AppIconButton(
                                icon: Icons.color_lens_outlined,
                                iconColor: Colors.green,
                                onPressed: () {
                                  context
                                      .read<PrimaryColorCubit>()
                                      .setGreenColor();
                                },
                              ),
                              const AppHSpace(),
                              AppIconButton(
                                icon: Icons.color_lens_outlined,
                                iconColor: Colors.blue,
                                onPressed: () {
                                  context
                                      .read<PrimaryColorCubit>()
                                      .setBlueColor();
                                },
                              ),
                              const AppHSpace(),
                              AppIconButton(
                                icon: Icons.color_lens_outlined,
                                iconColor: AppColors.primaryColor,
                                onPressed: () {
                                  context
                                      .read<PrimaryColorCubit>()
                                      .setPurpleColor();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void changeLanguageDialog(final BuildContext context) {
    appModalBottomSheetDialog(
      context,
      t.home_screen.language,
      '',
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.padding,
            ),
            title: Text(t.home_screen.french),
            onTap: () {
              context.pop();
              LocaleHandler().setFaLocale(context);
            },
            trailing: !checkEnState(context) ? const Icon(Icons.check) : null,
          ),
          const AppDivider(
            height: 0,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.padding,
            ),
            title: Text(t.home_screen.english),
            onTap: () {
              context.pop();
              LocaleHandler().setEnLocale(context);
            },
            trailing: checkEnState(context) ? const Icon(Icons.check) : null,
          ),
          const AppVSpace(),
        ],
      ),
    );
  }
}
