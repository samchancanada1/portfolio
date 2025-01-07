import 'package:flutter/material.dart';

import 'resume_item.dart';
import '../../../../core/theme/dimens.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/general_appbar.dart';
import '../../../../core/widgets/listview/app_list_view_builder.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class ResumeSectionWidget extends StatelessWidget {
  const ResumeSectionWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    final List<String> logos = [
      Assets.icons.mallIcon,
      Assets.icons.posIcon,
      Assets.icons.cvIcon,
      Assets.icons.vrIcon,
    ];
    final List<String> images = [
      Assets.images.mallImage.path,
      Assets.images.posImage.path,
      Assets.images.cvImage.path,
      Assets.images.vrImage.path,
    ];
    final List<String> titles = [
      "Smart Retail - Shopping Mall Mobile App",
      "Enterprise POS System for Coach Asia",
      "AI-Powered Resume Screening System (PoC Project)",
      "VR Hand-Tracking Game (Final Year Project)"
    ];
    final List<String> roles = [
      "Flutter Developer (Freelance)",
      "Developer",
      "AI Developer",
      "VR Developer"
    ];
    final List<String> workTimes = [
      "September 2022 – April 2023",
      "September 2019 – June 2022",
      "",
      "2019 (Final Year Project)",
    ];
    final List<String> descriptions = [
      '''Project Overview:
Developed a comprehensive mobile application to enhance the user experience for a shopping mall platform, seamlessly extending the functionality of its existing web services. The app provided users with real-time access to promotions, store directories, and event updates through a responsive and dynamic interface.

Key Contributions:
> REST API Integration: Built and integrated robust REST APIs to facilitate real-time data synchronization between the server and mobile app, ensuring data accuracy and consistency.
> Dynamic User Experience: Leveraged Flutter’s advanced widget system to create fluid and responsive UI components, optimizing performance across multiple screen sizes.
> Deep Linking: Implemented deep linking to provide users with direct access to specific sections of the app, improving navigation and user engagement.
> Collaborative Development: Engaged in full-cycle development, including requirements gathering, iterative design, testing, and deployment to production.

Technologies Used: Flutter, REST API, Git, JSON, Deep Linking''',
      '''Project Overview:
Led the development of a high-traffic Point of Sale (POS) system for Coach Asia, streamlining retail operations and enhancing transaction efficiency across multiple outlets. This large-scale enterprise solution catered to thousands of users, requiring high performance, scalability, and reliability.

Key Contributions:

> System Architecture & Development: Engineered and implemented key modules of the POS system using Flutter, ensuring seamless integration with legacy databases and hardware peripherals.
> Bug Resolution & Stability: Proactively identified and addressed software defects by analyzing bug reports and conducting thorough troubleshooting, enhancing overall system stability.
> Reusable Component Library: Designed and maintained reusable app templates and component libraries, accelerating development timelines and ensuring design consistency across products.
> MethodChannel Integration: Established native communication bridges via Flutter’s MethodChannel to integrate external devices, such as barcode scanners and receipt printers.
> Deep Linking: Developed deep linking features to facilitate in-app navigation between POS features and inventory management tools, streamlining the user experience for store managers.
> Testing & Validation: Conducted unit testing and stress tests to validate software integrity, ensuring the POS system met stringent performance benchmarks.

Technologies Used: Flutter, BloC, Git, JSON, MethodChannel, Deep Linking''',
      '''Project Overview:
Developed a cutting-edge AI resume parsing tool designed to revolutionize the recruitment process by automating candidate screening and matching. The tool employed Natural Language Processing (NLP) to analyze resumes, extracting job-related skills and experiences to generate a candidate relevance score.

Key Contributions:

> Data Preprocessing & Labeling: Collected, cleaned, and annotated resume data to train a Named Entity Recognition (NER) model, enabling precise extraction of job titles, skills, and experiences.
> Model Development: Utilized spaCy to build and fine-tune custom NER pipelines, significantly improving the model’s accuracy in parsing resumes across various industries.
> RESTful API Deployment: Packaged the AI model into a deployable REST API, allowing seamless integration with applicant tracking systems (ATS) and HR platforms.
> Enhanced Search Mechanism: Implemented Elasticsearch and TF-IDF (Term Frequency-Inverse Document Frequency) to score resumes and recommend the most suitable candidates by relevance, outperforming traditional keyword-based search methods.
> Candidate Matching: Designed algorithms to cross-reference job descriptions and resumes, enabling HR personnel to quickly identify top candidates and suggest alternative job openings based on candidate profiles.

Technologies Used: Python, spaCy, Selenium, Elasticsearch, FastAPI, Docker, TF-IDF''',
      '''Project Overview:
Created an immersive Virtual Reality (VR) game that leveraged Leap Motion technology to replace traditional handheld controllers, offering players a more natural and interactive gaming experience. The game utilized hand-tracking sensors to allow gesture-based gameplay, enhancing physical engagement.

Key Contributions:

> Gesture Control Integration: Implemented Leap Motion’s hand-tracking API to capture finger and hand movements, allowing users to interact with the virtual environment through natural gestures.
> 3D Asset Development: Designed and animated 3D assets using Maya and Blender, ensuring visually appealing game environments that responded dynamically to player actions.
> Game Mechanics Design: Programmed core game logic in Unity using C#, ensuring responsive interactions and realistic physics simulations to enhance user immersion.
> Multimodal Input: Combined gesture-based controls with voice recognition to expand interaction possibilities, allowing players to issue commands using both hands and voice.
> Performance Optimization: Optimized game performance by refining rendering processes and implementing LOD (Level of Detail) techniques to ensure smooth gameplay across different hardware configurations.

Technologies Used: Unity, Maya, Blender, C#'''
    ];
    final List<String> projectLinks = [
      "",
      "https://www.chainstoreplus.com/en/products/mpos",
      "",
      "https://www.youtube.com/watch?v=jyZSCdRjroY"
    ];
    return AppScaffold(
      appBar: GeneralAppBar(
        title: t.home_screen.resume,
      ),
      body: AppListViewBuilder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (final context, final index) {
          return ResumeItem(
            logo: logos[index],
            title: titles[index],
            workTime: workTimes[index],
            description: descriptions[index],
            projectLink: projectLinks[index],
            role: roles[index],
            imagePath: images[index],
          );
        },
        separatorBuilder: (final context, final index) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.largePadding,
            ),
            child: AppDivider(),
          );
        },
      ),
    );
  }
}
