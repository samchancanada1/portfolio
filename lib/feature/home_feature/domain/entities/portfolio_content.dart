import 'home_icon_key.dart';

class ResumeLink {
  const ResumeLink(this.label, this.url);

  final String label;
  final String url;
}

class SpotlightSummary {
  const SpotlightSummary({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
  });

  final String title;
  final String value;
  final String description;
  final HomeIconKey icon;
}

class StackSummary {
  const StackSummary({
    required this.title,
    required this.chips,
    required this.icon,
  });

  final String title;
  final List<String> chips;
  final HomeIconKey icon;
}

class FeatureHighlight {
  const FeatureHighlight({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final HomeIconKey icon;
}

class HeroProfile {
  const HeroProfile({
    required this.role,
    required this.eyebrow,
    required this.summary,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.spotlight,
    required this.metrics,
    required this.stack,
    required this.highlights,
  });

  final String role;
  final String eyebrow;
  final String summary;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final SpotlightSummary spotlight;
  final List<PortfolioStat> metrics;
  final StackSummary stack;
  final List<FeatureHighlight> highlights;
}

class ProfileInfo {
  const ProfileInfo(this.label, this.value);

  final String label;
  final String value;
}

class AboutProfile {
  const AboutProfile({
    required this.eyebrow,
    required this.title,
    required this.summary,
    required this.info,
  });

  final String eyebrow;
  final String title;
  final String summary;
  final List<ProfileInfo> info;
}

class CompetencyImpact {
  const CompetencyImpact({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final HomeIconKey icon;
}

class CoreCompetencies {
  const CoreCompetencies({
    required this.sectionEyebrow,
    required this.sectionTitle,
    required this.cardEyebrow,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badges,
    required this.impacts,
  });

  final String sectionEyebrow;
  final String sectionTitle;
  final String cardEyebrow;
  final String title;
  final String subtitle;
  final String description;
  final List<String> badges;
  final List<CompetencyImpact> impacts;
}

class SkillsOverview {
  const SkillsOverview({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.toolboxTitle,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String toolboxTitle;
}

class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.location,
    required this.period,
    required this.points,
    required this.tech,
    this.links = const [],
  });

  final String company;
  final String role;
  final String location;
  final String period;
  final List<String> points;
  final List<String> tech;
  final List<ResumeLink> links;
}

class DesignLens {
  const DesignLens(this.title, this.description, this.icon);

  final String title;
  final String description;
  final HomeIconKey icon;
}

class CapabilityGroup {
  const CapabilityGroup({
    required this.title,
    required this.description,
    required this.icon,
    required this.skills,
  });

  final String title;
  final String description;
  final HomeIconKey icon;
  final List<String> skills;
}

class PortfolioStat {
  const PortfolioStat(this.value, this.label, this.icon);

  final String value;
  final String label;
  final HomeIconKey icon;
}

class ContactAction {
  const ContactAction(
    this.label,
    this.icon,
    this.url, {
    this.logoPath,
  });

  final String label;
  final HomeIconKey icon;
  final String url;
  final String? logoPath;
}

class HomeContent {
  const HomeContent({
    required this.hero,
    required this.about,
    required this.coreCompetencies,
    required this.skillsOverview,
    required this.designLenses,
    required this.stats,
    required this.experiences,
    required this.capabilityGroups,
    required this.allSkills,
    required this.contactActions,
  });

  final HeroProfile hero;
  final AboutProfile about;
  final CoreCompetencies coreCompetencies;
  final SkillsOverview skillsOverview;
  final List<DesignLens> designLenses;
  final List<PortfolioStat> stats;
  final List<Experience> experiences;
  final List<CapabilityGroup> capabilityGroups;
  final List<String> allSkills;
  final List<ContactAction> contactActions;
}
