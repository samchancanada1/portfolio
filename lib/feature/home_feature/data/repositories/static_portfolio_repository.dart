import '../../domain/entities/home_icon_key.dart';
import '../../domain/entities/portfolio_content.dart';
import '../../domain/repositories/portfolio_repository.dart';

class StaticPortfolioRepository implements PortfolioRepository {
  const StaticPortfolioRepository();

  @override
  List<DesignLens> getDesignLenses() => _designLenses;

  @override
  List<PortfolioStat> getStats() => _stats;

  @override
  List<Experience> getExperiences() => _experiences;

  @override
  List<CapabilityGroup> getCapabilityGroups() => _capabilityGroups;

  @override
  List<String> getAllSkills() => _allSkills;

  @override
  List<ContactAction> getContactActions() => _contactActions;
}

const List<DesignLens> _designLenses = [
  DesignLens(
    'UX flows',
    'Clear journeys from first tap to released feature.',
    HomeIconKey.route,
  ),
  DesignLens(
    'Visual systems',
    'Reusable spacing, type, color, and component rules.',
    HomeIconKey.dashboardCustomize,
  ),
  DesignLens(
    'Responsive craft',
    'Independent sizing for phone, tablet, desktop, and web.',
    HomeIconKey.devices,
  ),
  DesignLens(
    'Product polish',
    'Empty, loading, error, accessibility, and release states.',
    HomeIconKey.autoAwesome,
  ),
];

const List<PortfolioStat> _stats = [
  PortfolioStat('6+', 'Years mobile development', HomeIconKey.timeline),
  PortfolioStat('2', 'Live store releases', HomeIconKey.rocketLaunch),
  PortfolioStat('5', 'Product domains', HomeIconKey.dashboardCustomize),
  PortfolioStat('35+', 'Android API target', HomeIconKey.android),
];

const List<CapabilityGroup> _capabilityGroups = [
  CapabilityGroup(
    title: 'Mobile',
    description:
        'Cross-platform mobile development for Android, iOS, and web using Flutter and Dart, with native Kotlin and Swift modules when platform capabilities are needed.',
    icon: HomeIconKey.phone,
    skills: ['Flutter', 'Dart', 'Android', 'iOS', 'Kotlin', 'Swift'],
  ),
  CapabilityGroup(
    title: 'Architecture',
    description:
        'Maintainable Flutter app structures with Clean Architecture, modular service layers, dependency injection, and practical state management.',
    icon: HomeIconKey.accountTree,
    skills: ['Clean Architecture', 'BLoC', 'Riverpod', 'Provider', 'GetIt'],
  ),
  CapabilityGroup(
    title: 'Backend and APIs',
    description:
        'Firebase-backed app features and API integrations for authentication, real-time data, notifications, analytics, and business workflows.',
    icon: HomeIconKey.cloudDone,
    skills: [
      'Firebase Auth',
      'Firestore',
      'Cloud Messaging',
      'Analytics',
      'REST APIs',
      '.NET APIs',
      'Spring APIs',
    ],
  ),
  CapabilityGroup(
    title: 'CI/CD and release',
    description:
        'Release workflows covering automated builds, testing, signing, TestFlight, App Store, Google Play, Docker, and GitHub Actions.',
    icon: HomeIconKey.rocketLaunch,
    skills: [
      'Git',
      'GitHub Actions',
      'Docker',
      'TestFlight',
      'App Store',
      'Google Play',
      'Code Signing',
    ],
  ),
  CapabilityGroup(
    title: 'Mobile features',
    description:
        'Practical app features that support production mobile behavior, device connectivity, offline use, deep linking, lifecycle handling, and notifications.',
    icon: HomeIconKey.hub,
    skills: [
      'Push Notifications',
      'Deep Linking',
      'Platform Channels',
      'App Lifecycle',
      'Offline-first',
      'BLE',
      'SQLite',
      'Hive',
    ],
  ),
  CapabilityGroup(
    title: 'Testing and other',
    description:
        'Testing, backend proof-of-concept, search, and tooling experience from production work and the AI Resume Parser project.',
    icon: HomeIconKey.factCheck,
    skills: [
      'flutter_test',
      'mockito',
      'integration_test',
      'Python',
      'C#',
      'FastAPI',
      'Elasticsearch',
      'Unity',
    ],
  ),
];

const List<String> _allSkills = [
  'Flutter (Android, iOS, Web)',
  'Dart',
  'Clean Architecture',
  'BLoC',
  'Riverpod',
  'Provider',
  'GetIt',
  'GoRouter',
  'Firebase Auth',
  'Firestore',
  'Firebase Cloud Messaging',
  'Firebase Analytics',
  'REST APIs',
  '.NET APIs',
  'Spring APIs',
  'GitHub Actions',
  'Docker',
  'TestFlight',
  'App Store',
  'Google Play',
  'Code Signing',
  'Platform Channels',
  'Deep Linking',
  'App Lifecycle',
  'Push Notifications',
  'Offline-first',
  'BLE',
  'SQLite',
  'Hive',
  'Kotlin',
  'Swift',
  'Git and GitHub',
  'flutter_test',
  'mockito',
  'integration_test',
  'Python',
  'C#',
  'FastAPI',
  'Elasticsearch',
  'Unity',
];

const List<ContactAction> _contactActions = [
  ContactAction(
    'LinkedIn',
    HomeIconKey.businessCenter,
    'https://www.linkedin.com/in/hiu-tung-chan-051b61231/',
    logoPath: 'assets/icons/linkedin_icon.png',
  ),
  ContactAction(
    'GitHub',
    HomeIconKey.code,
    'https://github.com/samchancanada1',
    logoPath: 'assets/icons/github_logo.png',
  ),
  ContactAction(
    'Stack Overflow',
    HomeIconKey.questionAnswer,
    'https://stackoverflow.com/users/14233004/sam-chan',
    logoPath: 'assets/icons/stackoverflow_icon.png',
  ),
  ContactAction(
    'WhatsApp',
    HomeIconKey.chat,
    'https://wa.me/+14376628303',
    logoPath: 'assets/icons/whatsapp_logo.png',
  ),
  ContactAction(
    'Email',
    HomeIconKey.mail,
    'mailto:samchancanada1@gmail.com?subject=We%20are%20interested%20in%20you!',
  ),
];

const List<Experience> _experiences = [
  Experience(
    company: 'BoursePad',
    role: 'Flutter Developer',
    location: 'Remote / Toronto',
    period: 'Jun 2025 - Present',
    points: [
      'Enhanced and maintained a production Flutter scholarship-matching application with a focus on scalability, accessibility, performance, and long-term maintainability.',
      'Applied Clean Architecture with Riverpod, GoRouter, GetIt, and modular feature-based structure to improve separation, testability, and maintainability.',
      'Upgraded the app for Xcode 16 and Android API 35+ requirements, keeping releases aligned with current App Store and Google Play standards.',
      'Integrated Firebase Auth, Firestore, Cloud Messaging, and Analytics for authentication, real-time data, notifications, communication, and product insights.',
      'Built CI/CD pipelines from scratch using GitHub Actions for automated build, test, deployment, multi-environment release workflows, and regression risk reduction.',
      'Managed App Store and Google Play release workflows including provisioning profiles, code signing, release builds, version control, and store submission requirements.',
      'Implemented cross-platform mobile features including App Lifecycle handling, Platform Channels, deep linking, and native integration for reliable iOS and Android behavior.',
    ],
    tech: [
      'Flutter',
      'Clean Architecture',
      'Riverpod',
      'GoRouter',
      'GetIt',
      'Firebase',
      'GitHub Actions',
      'App Store',
      'Google Play',
    ],
    links: [
      ResumeLink(
        'App Store',
        'https://apps.apple.com/us/app/boursepad/id6738283933',
      ),
      ResumeLink(
        'Google Play',
        'https://play.google.com/store/apps/details?id=com.eruditio.boursepad',
      ),
    ],
  ),
  Experience(
    company: 'KeelWorks Foundation',
    role: 'Mobile Developer',
    location: 'Remote',
    period: 'Jan 2025 - Jun 2025',
    points: [
      'Developed a Flutter mobile application for real-time water usage tracking and conservation insights.',
      'Structured core modules with BLoC to separate business logic from UI and improve maintainability.',
      'Integrated secure REST APIs with backend services for reliable user-specific usage records.',
      'Built interactive charts and dashboard components to present consumption trends clearly on mobile.',
      'Improved onboarding, navigation, and UI flows for a smoother cross-platform user experience.',
    ],
    tech: ['Flutter', 'BLoC', 'REST APIs', 'Charts', 'Mobile UX'],
  ),
  Experience(
    company: 'Independent Flutter Developer',
    role: 'Flutter Developer',
    location: 'Remote / Part-time Contract',
    period: 'May 2022 - Present',
    points: [
      'Built early-stage Flutter apps and internal tools for clients across retail, IoT, and fitness domains.',
      'Worked directly with clients to clarify business logic and translate operational needs into practical mobile workflows.',
      'Designed scalable Flutter structures with Dart, BLoC/Provider, reusable UI components, and modular service layers.',
      'Made architecture and implementation decisions by balancing performance, development timeline, budget constraints, and long-term maintainability.',
      'Integrated REST APIs, push notifications, authentication flows, and third-party SDKs for MVP and internal-use app requirements.',
      'Developed platform-specific Kotlin and Swift modules for native device capabilities including sensors, Bluetooth communication, and background behavior.',
      'Implemented Bluetooth Low Energy and offline-first functionality with SQLite and Hive for reliability under network and device constraints.',
    ],
    tech: [
      'Flutter',
      'BLoC',
      'Provider',
      'Kotlin',
      'Swift',
      'BLE',
      'SQLite',
      'Hive',
    ],
  ),
  Experience(
    company: 'Computer And Technologies Holdings',
    role: 'Developer',
    location: 'Hong Kong',
    period: 'Sep 2019 - May 2022',
    points: [
      'Contributed to migrating a legacy POS system into a mobile-first Flutter solution for COACH Asia retail operations.',
      'Worked with business and technical stakeholders to understand retail transaction logic, inventory workflows, payment scenarios, and operational requirements.',
      'Integrated Flutter apps with a .NET backend and REST APIs for order processing, inventory updates, and retail workflow synchronization.',
      'Designed modular UI components and service layers to improve maintainability, reduce repeated implementation effort, and support future feature expansion.',
      'Implemented deep linking and Alipay payment integration to support smoother and more secure transaction flows.',
      'Integrated BLE communication for portable barcode scanners and thermal printers.',
      'Supported multilingual Chinese and English retail workflows, code reviews, debugging, and production stability improvements.',
    ],
    tech: ['Flutter', '.NET APIs', 'REST APIs', 'Alipay', 'BLE'],
    links: [
      ResumeLink(
        'Coach Asia POS',
        'https://www.chainstoreplus.com/en/products/mpos',
      ),
    ],
  ),
  Experience(
    company: 'AI Resume Parser',
    role: 'Additional Project',
    location: 'Proof of concept',
    period: 'Project',
    points: [
      'Built a proof-of-concept AI-powered resume screening backend with FastAPI REST APIs.',
      'Implemented Elasticsearch search and retrieval, contextual skill matching, custom scoring workflows, and Dockerized development/deployment support.',
    ],
    tech: ['Python', 'spaCy', 'FastAPI', 'Docker', 'Elasticsearch'],
  ),
];
