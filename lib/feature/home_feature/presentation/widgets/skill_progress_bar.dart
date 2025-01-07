import 'package:flutter/material.dart';

import '../../../../core/utils/sized_context.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/check_desktop_size.dart';
import '../../../../core/widgets/app_space.dart';

class SkillProgressBarItems extends StatelessWidget {
  const SkillProgressBarItems({super.key});
/*
Flutter (85%) – Expertise in developing cross-platform mobile applications, including point-of-sale systems and shopping mall apps.
Dart (80%) – Primary programming language for Flutter development, enabling seamless UI and business logic implementation.
Git (80%) – Proficient in version control, managing codebases, and collaborative development across multiple projects.
REST APIs (75%) – Strong experience in integrating and developing RESTful APIs for mobile and backend services.
JSON (75%) – Regularly used for data exchange between mobile apps and backend services.
Python (70%) – Applied in AI, automation, and data parsing projects, particularly in backend API development.
C# (65%) – Used in VR and gaming projects, contributing to immersive experiences with Unity and Leap Motion.
spaCy (65%) – Leveraged for natural language processing (NLP) tasks in AI projects such as resume parsing and candidate screening.
FastAPI (60%) – Built and deployed backend RESTful APIs, often used in conjunction with AI models and data services.
Docker (60%) – Containerized applications and AI models to streamline deployment and scaling.
Java (60%) – Backend and application development for general-purpose software projects.
C++ (55%) – Applied in embedded systems and foundational programming tasks, especially during educational and early career projects.
Elasticsearch (55%) – Used for efficient data retrieval, indexing, and AI-driven search functionality.*/
  @override
  Widget build(final BuildContext context) {
    Map<String, double> skillsSet = {
      'Flutter': 90,
      "Dart": 80,
      "Git": 80,
      "REST APIs": 75,
      "Python": 70,
      "C#": 65,
      "spaCy": 65,
      "FastAPI": 60,
      "Docker": 60,
      "Java": 60,
      "C++": 55,
      "Elasticsearch": 55,
    };
    List<String> skillsList = skillsSet.keys.toList();

    if (checkDesktopSize(context)) {
      List<Widget> skillsWidget = [];
      for (int i = 0; i < skillsList.length; i += 2) {
        skillsWidget.add(
          Row(
            children: [
              Expanded(
                child: SkillProgressBar(
                  title: skillsList[i],
                  percentage: skillsSet[skillsList[i]]!,
                ),
              ),
              Expanded(
                child: SkillProgressBar(
                  title: skillsList[i + 1],
                  percentage: skillsSet[skillsList[i + 1]]!,
                ),
              ),
            ],
          ),
        );
        if (i != skillsList.length - 2) {
          skillsWidget.add(AppVSpace());
        }
      }
      return Column(
        children: skillsWidget,
      );
    } else {
      return Column(children: [
        ...skillsList.map((skill) => SkillProgressBar(
              title: skill,
              percentage: skillsSet[skill]!,
            ))
      ]);
    }
  }
}

class SkillProgressBar extends StatelessWidget {
  const SkillProgressBar({
    super.key,
    required this.title,
    required this.percentage,
  });

  final String title;
  final double percentage;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.largePadding,
      ),
      child: SizedBox(
        width:
            checkDesktopSize(context) ? context.widthPx / 2 : context.widthPx,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Text('$percentage%'),
              ],
            ),
            const AppVSpace(
              space: Dimens.mediumPadding,
            ),
            LinearProgressIndicator(
              value: percentage / 100,
              borderRadius: BorderRadius.circular(100),
              minHeight: 8.0,
            ),
            const AppVSpace(),
          ],
        ),
      ),
    );
  }
}
