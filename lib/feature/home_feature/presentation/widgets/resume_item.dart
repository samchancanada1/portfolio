import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/dimens.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/app_svg_viewer.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../i18n/strings.g.dart';

class ResumeItem extends StatefulWidget {
  const ResumeItem(
      {super.key,
      required this.logo,
      required this.title,
      required this.workTime,
      this.role = "",
      required this.description,
      required this.projectLink,
      this.imagePath = ''});

  final String logo;
  final String title;
  final String workTime;
  final String description;
  final String projectLink;
  final String role;
  final String imagePath;
  @override
  State<ResumeItem> createState() => _ResumeItemState();
}

class _ResumeItemState extends State<ResumeItem> {
  bool _tileExpanded = false;
  late ExpansionTileController _expansionTileController;

  @override
  void initState() {
    super.initState();
    _expansionTileController = ExpansionTileController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ExpansionTile(
      controller: _expansionTileController,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _tileExpanded = expanded;
        });
      },
      leading: (_tileExpanded)
          ? null
          : AppSvgViewer(
              path: widget.logo,
              size: 60,
              setDefaultColor: false,
            ),
      trailing: SizedBox(
        width: 100,
        child: AppButton(
            title: t.home_screen.view,
            onPressed: () {
              // setState(() {});
              if (_expansionTileController.isExpanded) {
                _expansionTileController.collapse();
              } else {
                _expansionTileController.expand();
              }
            }),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          (widget.role.isNotEmpty)
              ? Opacity(
                  opacity: 0.8,
                  child: Text(widget.role),
                )
              : Container(),
          Opacity(
            opacity: 0.8,
            child: Text(widget.workTime),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Dimens.largePadding),
            ],
          ),
          const AppVSpace(),
        ],
      ),
      children: <Widget>[
        ListTile(
            title: Column(
          children: [
            const AppVSpace(),
            Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
            if (widget.projectLink.isNotEmpty) const AppVSpace(),
            if (widget.projectLink.isNotEmpty)
              InkWell(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Project link : ${widget.projectLink}',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () async {
                  await launchUrl(Uri.parse(widget.projectLink));
                },
              ),
            const AppVSpace(),
            Text(
              widget.description,
            ),
          ],
        )),
      ],
    );
  }
}
