import '../../domain/entities/home_icon_key.dart';
import '../../domain/entities/portfolio_content.dart';
import '../../domain/repositories/portfolio_repository.dart';

class StaticPortfolioRepository implements PortfolioRepository {
  const StaticPortfolioRepository();

  @override
  HeroProfile getHeroProfile() => _heroProfile;

  @override
  AboutProfile getAboutProfile() => _aboutProfile;

  @override
  CoreCompetencies getCoreCompetencies() => _coreCompetencies;

  @override
  SkillsOverview getSkillsOverview() => _skillsOverview;

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

const HeroProfile _heroProfile = HeroProfile(
  role: 'Senior Flutter & Mobile Application Developer',
  eyebrow: 'iOS / Android / Flutter Web',
  summary:
      'Production Flutter apps across education, construction, retail POS, and IoT.',
  primaryActionLabel: 'View case studies',
  secondaryActionLabel: 'Start a conversation',
  spotlight: SpotlightSummary(
    icon: HomeIconKey.autoAwesome,
    title: 'Current ownership',
    value: 'BoursePad + construction platform',
    description:
        'Primary mobile developer for a production education technology platform, while leading full-stack delivery for a construction workforce platform with Flutter, Flutter Web, Firebase, and Cloud Functions.',
  ),
  metrics: [
    PortfolioStat('6+', 'Years experience', HomeIconKey.timeline),
    PortfolioStat('iOS + Android', 'Store releases', HomeIconKey.rocketLaunch),
  ],
  stack: StackSummary(
    title: 'Built around',
    icon: HomeIconKey.accountTree,
    chips: [
      'Flutter',
      'Clean Architecture',
      'Riverpod',
      'BLoC',
      'Firebase',
      'Cloud Functions',
      'Native integrations',
    ],
  ),
  highlights: [
    FeatureHighlight(
      icon: HomeIconKey.checkCircle,
      title: 'Product ownership',
      description: 'Architecture, delivery, release, support',
    ),
    FeatureHighlight(
      icon: HomeIconKey.bluetooth,
      title: 'Platform range',
      description: 'Flutter Web, Kotlin, Swift, Java, BLE',
    ),
  ],
);

const AboutProfile _aboutProfile = AboutProfile(
  eyebrow: 'Profile',
  title: 'Senior mobile development with end-to-end product ownership',
  summary:
      'Senior Flutter & Mobile Application Developer with 6+ years of experience designing, delivering, and supporting iOS, Android, and Flutter Web applications. My work spans product ownership, mobile and system architecture, native Java/Kotlin/Swift integrations, Firebase serverless backends, REST APIs, offline-first workflows, CI/CD, release management, and production support.',
  info: [
    ProfileInfo('Website', 'samchancanada1.github.io/portfolio'),
    ProfileInfo('Phone', '+1 (437) 662-8303'),
    ProfileInfo('City', 'Markham, ON, CA'),
    ProfileInfo('Degree', 'Bachelor of Engineering'),
    ProfileInfo('Email', 'samchancanada1@gmail.com'),
    ProfileInfo('Languages', 'English, Cantonese, Mandarin'),
    ProfileInfo('Work', 'Authorized to work in Canada'),
  ],
);

const CoreCompetencies _coreCompetencies = CoreCompetencies(
  sectionEyebrow: 'Professional experience',
  sectionTitle: '6+ years building production Flutter apps',
  cardEyebrow: 'Core competencies',
  title:
      'Mobile product ownership, architecture, native integrations, backend delivery, and release support',
  subtitle: 'What I bring to a product team',
  description:
      'Across my recent work, the common thread is ownership: turning business requirements into maintainable Flutter products, connecting Firebase and enterprise APIs, handling native platform details, and supporting releases after launch.',
  badges: [
    'End-to-end ownership',
    'Mobile architecture',
    'Firebase serverless',
    'REST integration',
    'Offline-first workflows',
    'Production support',
  ],
  impacts: [
    CompetencyImpact(
      icon: HomeIconKey.phone,
      title: 'Mobile & web',
      description: 'Flutter, Dart, Flutter Web, iOS, Android',
    ),
    CompetencyImpact(
      icon: HomeIconKey.api,
      title: 'Cloud & APIs',
      description: 'Firebase, Cloud Functions, REST, .NET, Spring',
    ),
    CompetencyImpact(
      icon: HomeIconKey.accountTree,
      title: 'Architecture',
      description: 'Clean Architecture, OOD, BLoC, Riverpod, GetIt',
    ),
    CompetencyImpact(
      icon: HomeIconKey.storefront,
      title: 'Release',
      description: 'GitHub Actions, Fastlane, TestFlight, stores',
    ),
  ],
);

const SkillsOverview _skillsOverview = SkillsOverview(
  eyebrow: 'Capabilities',
  title: 'Production-ready mobile skills',
  description:
      'A practical skill set for shipping cross-platform apps: Flutter delivery, architecture, Firebase and serverless backends, enterprise API integration, native platform work, CI/CD, testing, and release support.',
  toolboxTitle: 'Technical toolbox',
);

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
  PortfolioStat('3', 'iOS, Android, Web', HomeIconKey.devices),
  PortfolioStat('5', 'Product domains', HomeIconKey.dashboardCustomize),
  PortfolioStat(
      'CI/CD', 'Build, signing, release support', HomeIconKey.rocketLaunch),
];

const List<CapabilityGroup> _capabilityGroups = [
  CapabilityGroup(
    title: 'Mobile',
    description:
        'Cross-platform mobile and web development using Flutter and Dart, with native Java, Kotlin, and Swift integration when platform capabilities are needed.',
    icon: HomeIconKey.phone,
    skills: [
      'Flutter',
      'Dart',
      'Flutter Web',
      'iOS',
      'Android',
      'Swift',
      'Kotlin',
      'Java'
    ],
  ),
  CapabilityGroup(
    title: 'Architecture',
    description:
        'Maintainable app structures using Clean Architecture, object-oriented design, design patterns, modular service layers, dependency injection, and practical state management.',
    icon: HomeIconKey.accountTree,
    skills: [
      'Clean Architecture',
      'Object-Oriented Design',
      'Design Patterns',
      'BLoC',
      'Riverpod',
      'Provider',
      'GetIt',
      'GoRouter',
    ],
  ),
  CapabilityGroup(
    title: 'Backend and cloud',
    description:
        'Firebase-backed product features and serverless backend work for authentication, real-time data, storage, notifications, analytics, and event-driven workflows.',
    icon: HomeIconKey.cloudDone,
    skills: [
      'Firebase Auth',
      'Firestore',
      'Cloud Storage',
      'Cloud Functions',
      'Cloud Messaging',
      'Analytics',
      'FastAPI',
      'Python',
    ],
  ),
  CapabilityGroup(
    title: 'APIs and data',
    description:
        'REST API design and integration across Firebase, enterprise .NET and Spring services, offline-first storage, and third-party SDKs.',
    icon: HomeIconKey.api,
    skills: [
      'REST APIs',
      '.NET APIs',
      'Spring APIs',
      'SQLite',
      'Hive',
      'Offline-first data sync',
      'Third-party SDKs',
    ],
  ),
  CapabilityGroup(
    title: 'CI/CD and release',
    description:
        'Release workflows covering automated builds, testing, signing, Fastlane, TestFlight, App Store Connect, Google Play Console, Docker, and GitHub Actions.',
    icon: HomeIconKey.rocketLaunch,
    skills: [
      'Git',
      'GitHub Actions',
      'Fastlane',
      'Docker',
      'TestFlight',
      'App Store Connect',
      'Google Play Console',
      'Code Signing',
    ],
  ),
  CapabilityGroup(
    title: 'Platform capabilities',
    description:
        'Device and platform work across Platform Channels, BLE, barcode scanners, thermal printers, notifications, deep linking, app lifecycle, and background processing.',
    icon: HomeIconKey.hub,
    skills: [
      'Platform Channels',
      'BLE',
      'Barcode Scanners',
      'Thermal Printers',
      'Push Notifications',
      'Deep Linking',
      'App Lifecycle',
      'Background Processing',
    ],
  ),
  CapabilityGroup(
    title: 'Testing and AI tooling',
    description:
        'Automated testing, Dockerized backend prototypes, parsing, scoring, search, and retrieval across shipped apps and AI Resume Parser.',
    icon: HomeIconKey.factCheck,
    skills: [
      'flutter_test',
      'mockito',
      'integration_test',
      'Elasticsearch',
      'spaCy',
      'C#',
    ],
  ),
];

const List<String> _allSkills = [
  'Flutter (Android, iOS, Web)',
  'Dart',
  'Flutter Web',
  'iOS',
  'Android',
  'Swift',
  'Kotlin',
  'Java',
  'Clean Architecture',
  'Object-Oriented Design',
  'Design Patterns',
  'BLoC',
  'Riverpod',
  'Provider',
  'GetIt',
  'GoRouter',
  'Firebase Auth',
  'Firestore',
  'Cloud Storage',
  'Cloud Functions',
  'Firebase Cloud Messaging',
  'Firebase Analytics',
  'FastAPI',
  'Python',
  'REST APIs',
  'REST API Design',
  '.NET APIs',
  'Spring APIs',
  'SQLite',
  'Hive',
  'Offline-first data sync',
  'Third-party SDKs',
  'Platform Channels',
  'BLE',
  'Barcode Scanners',
  'Thermal Printers',
  'Push Notifications',
  'Deep Linking',
  'App Lifecycle',
  'Background Processing',
  'Git and GitHub',
  'GitHub Actions',
  'Fastlane',
  'Docker',
  'TestFlight',
  'App Store Connect',
  'Google Play Console',
  'Code Signing',
  'flutter_test',
  'mockito',
  'integration_test',
  'Elasticsearch',
  'spaCy',
  'C#',
];

const List<ContactAction> _contactActions = [
  ContactAction(
    'LinkedIn',
    HomeIconKey.businessCenter,
    'https://www.linkedin.com/in/samhiutungchan',
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
      'Serve as the primary mobile developer for a production education technology platform, owning ongoing product development, production reliability, iOS and Android releases, and post-release support.',
      'Translate scholarship requests, sponsor contribution workflows, authentication, profile and document verification, messaging, and notifications into maintainable cross-platform features.',
      'Design and evolve modular feature-based Flutter architecture using Clean Architecture, Riverpod, GoRouter, and GetIt to improve separation of concerns, testability, scalability, and maintainability.',
      'Integrate Firebase Authentication, Firestore, Firebase Cloud Messaging, and Analytics while optimizing query strategies, data-loading patterns, and real-time listeners to reduce unnecessary reads.',
      'Designed and implemented CI/CD from scratch with GitHub Actions, automating testing, build generation, code signing, and deployment across development, staging, and production.',
      'Own native configuration, provisioning profiles, code signing, versioning, platform compliance, store submissions, deep linking, app lifecycle handling, and Platform Channel integrations with Swift and Kotlin modules.',
    ],
    tech: [
      'Flutter',
      'Clean Architecture',
      'Riverpod',
      'GoRouter',
      'GetIt',
      'Firebase Auth',
      'Firestore',
      'Cloud Messaging',
      'Analytics',
      'GitHub Actions',
      'Swift',
      'Kotlin',
      'App Store Connect',
      'Google Play Console',
    ],
    screenPaths: [
      'assets/images/boursepad-discovery-store-v2.png',
      'assets/images/boursepad-scholarship-store-v2.png',
      'assets/images/boursepad-verification-store-v2.png',
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
    company: 'Independent Contractor - Project-Based Client Engagements',
    role: 'Mobile & Full-Stack Developer',
    location: 'Remote',
    period: 'May 2022 - Present',
    points: [
      'Delivered mobile, Flutter Web, and serverless backend solutions for clients across construction technology, IoT, retail, and fitness.',
      'Owned delivery from requirements discovery and system architecture through implementation, testing, deployment, stakeholder review, and ongoing iteration.',
      'Lead the architecture and full-stack delivery of a construction workforce platform spanning a Flutter contractor app, Flutter Web company and administrative portals, and Firebase serverless backend services.',
      'Implemented role-based access, identity and document verification, contractor queue management, workforce requests, notifications, administrative review, Cloud Storage, and event-driven Cloud Functions.',
      'Designed data flows, system boundaries, access controls, offline strategies, and integration approaches while balancing security, timelines, scalability, and long-term maintainability.',
    ],
    tech: [
      'Flutter',
      'Flutter Web',
      'Firebase',
      'Cloud Functions',
      'Cloud Storage',
      'REST APIs',
      'Access Control',
      'Offline-first',
    ],
    screenPaths: [
      'assets/images/construction-workforce-dashboard-mockup.png',
      'assets/images/construction-documents-mockup.png',
      'assets/images/construction-admin-mockup.png',
    ],
  ),
  Experience(
    company: 'KeelWorks Foundation',
    role: 'Mobile Developer',
    location: 'Remote',
    period: 'Jan 2025 - Jun 2025',
    points: [
      'Developed a Flutter application for real-time water usage monitoring, including interactive dashboards, consumption charts, and user-specific usage records.',
      'Structured application modules using BLoC and integrated secure REST APIs, separating business logic from the user interface and supporting reliable data exchange.',
      'Improved onboarding, navigation, dashboard presentation, and cross-platform mobile workflows to deliver a clearer and more accessible user experience.',
    ],
    tech: ['Flutter', 'BLoC', 'REST APIs', 'Charts', 'Mobile UX'],
    screenPaths: [
      'assets/images/keelworks-overview-mockup.png',
      'assets/images/keelworks-usage-mockup.png',
      'assets/images/keelworks-save-mockup.png',
    ],
  ),
  Experience(
    company: 'Computer And Technologies Holdings Limited',
    role: 'Developer (Mobile Applications)',
    location: 'Hong Kong',
    period: 'Sep 2019 - May 2022',
    points: [
      'Contributed to a multi-year enterprise modernization initiative migrating the COACH Asia legacy POS platform to a Flutter-based mobile solution across five Asian markets.',
      'Collaborated with business analysts, technical teams, and retail stakeholders to translate transaction, inventory, payment, and operational requirements into scalable mobile solution designs.',
      'Integrated Flutter applications with .NET backend services and REST APIs to support real-time and near-real-time order processing, inventory synchronization, and retail transaction workflows.',
      'Developed and maintained native Android integrations using Java and Kotlin for platform-specific services, retail peripherals, and device functionality.',
      'Designed reusable Flutter components, native integration layers, and modular service structures using object-oriented principles and design patterns.',
      'Integrated BLE barcode scanners, thermal printers, third-party payment integrations, deep linking, and multilingual workflows for Chinese- and English-speaking retail teams.',
      'Investigated production issues across Flutter and native Android components and contributed to code reviews, Git workflows, release validation, performance improvements, and support.',
    ],
    tech: [
      'Flutter',
      '.NET APIs',
      'REST APIs',
      'Java',
      'Kotlin',
      'BLE',
      'Barcode Scanners',
      'Thermal Printers',
      'Deep Linking',
    ],
    screenPaths: [
      'assets/images/retail-pos-mockup.png',
      'assets/images/coach-products-mockup.png',
      'assets/images/coach-payment-mockup.png',
    ],
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
      'Built a prototype backend service using Python, FastAPI, spaCy, Elasticsearch, and Docker.',
      'Exposed REST APIs for resume ingestion, parsing, contextual skill matching, candidate scoring, search, and retrieval.',
      'Structured API, service, and data-processing layers to support testing and future integration with web or mobile clients.',
    ],
    tech: ['Python', 'spaCy', 'FastAPI', 'Docker', 'Elasticsearch'],
    screenPaths: [
      'assets/images/ai-parser-upload-mockup.png',
      'assets/images/ai-parser-profile-mockup.png',
      'assets/images/ai-parser-search-mockup.png',
    ],
  ),
];
