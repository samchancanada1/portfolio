import 'package:flutter/material.dart';

import 'skill_progress_bar.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/utils/get_primary_color.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_space.dart';
import '../../../../core/widgets/general_appbar.dart';
import '../../../../core/widgets/listview/app_list_view_builder.dart';
import '../../../../core/widgets/listview/app_single_child_scroll_view.dart';
import '../../../../core/widgets/typography/app_title_text.dart';
import '../../../../i18n/strings.g.dart';

class SkillsSectionWidget extends StatelessWidget {
  const SkillsSectionWidget({super.key});

  @override
  Widget build(final BuildContext context) {
/*
All Skills List (with Descriptions):
Mobile Development:
Flutter – Cross-platform mobile app development framework.
Dart – Primary language for Flutter apps, known for its speed and flexibility.
Deep Linking – Creates seamless navigation within mobile apps by linking specific pages.
MethodChannel – Bridges Flutter with native Android/iOS code to extend functionality.
Bluetooth Integration – Connected mobile devices to external peripherals such as barcode scanners and printers.
Firebase – Used for real-time databases, push notifications, and cloud storage in mobile apps.
Backend Development:
Python – Core language for backend automation, AI development, and API creation.
FastAPI – Modern web framework for building fast, efficient APIs using Python.
Docker – Containerization tool that simplifies deployment and ensures consistency across environments.
REST APIs – Foundation of web services, allowing communication between mobile apps and servers.
GraphQL – Query language for APIs, providing more flexibility than traditional REST.
MySQL – Relational database management for storing and querying structured data.
Elasticsearch – Search and analytics engine used for fast and accurate data retrieval.
AI & Data Processing:
spaCy – NLP library for processing and parsing large volumes of text.
Selenium – Automated web scraping and testing framework.
AI Model Deployment – Packaging AI models as services to integrate with other applications.
VR Development:
Unity – Game engine used for VR development, including immersive environments and simulations.
Leap Motion – Hand-tracking technology used for VR and gesture-based interactions.
C# – Primary language for scripting in Unity projects.
Maya/Blender – 3D modeling and animation tools for VR and game development.
General Development Tools:
Git – Version control system for managing source code.
Java – Versatile language used for mobile and backend development.
C++ – Used for performance-critical applications and system programming.
JavaScript – Basic experience in web and app development.
Swift/Kotlin – Exposure to native iOS (Swift) and Android (Kotlin) development.
CI/CD – Continuous integration and deployment for automating build and release processes.
Linux – Development in Unix-like environments, often for backend services
*/
    final List<String> skillsList = [
      'Flutter (Android, iOS, Web)',
      'State Managements (Bloc, Provider)',
      'Clean architecture',
      'Ui design (Material and Cupertino)',
      'MethodChannel'
          'Deep Linking',
      'Bluetooth Integration',
      'API Integration (Rest API, Web socket, SignalR)',
      'Version control systems (Git, Github)',
      'Design Principles (OOP, SOLID, Design Patterns, Dependency Injection)',
      'Python',
      'FastAPI',
      'Docker',
      'REST APIs',
      'GraphQL',
      'MySQL',
      'Elasticsearch',
      'Firebase (Authentication, Push notification, FireStore, etc)',
      'Testing (unit test, widget test)',
      'spaCy',
      'Selenium',
      'AI Model Deployment',
      'Unity',
      'Leap Motion',
      'C#',
      'Maya/Blender',
      'Git',
      'Java',
      'C++',
      'JavaScript',
      'Swift/Kotlin',
      'CI/CD',
      'Linux'
    ];
    return AppScaffold(
      appBar: GeneralAppBar(
        title: t.home_screen.skills,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.largePadding),
        child: AppSingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitleText(t.home_screen.coreSkills),
              const AppVSpace(),
              const SkillProgressBarItems(),
              const AppVSpace(
                space: Dimens.veryLargePadding,
              ),
              AppTitleText(t.home_screen.allSkills),
              const AppVSpace(),
              AppListViewBuilder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: skillsList.length,
                itemBuilder: (final context, final index) {
                  return ListTile(
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: getPrimaryColor(context),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                    ),
                    title: Text(skillsList[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
