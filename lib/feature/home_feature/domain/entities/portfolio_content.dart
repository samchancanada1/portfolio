import 'home_icon_key.dart';

class ResumeLink {
  const ResumeLink(this.label, this.url);

  final String label;
  final String url;
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
