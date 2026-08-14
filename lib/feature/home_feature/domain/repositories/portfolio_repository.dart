import '../entities/portfolio_content.dart';

abstract class PortfolioRepository {
  HeroProfile getHeroProfile();

  AboutProfile getAboutProfile();

  CoreCompetencies getCoreCompetencies();

  SkillsOverview getSkillsOverview();

  List<DesignLens> getDesignLenses();

  List<PortfolioStat> getStats();

  List<Experience> getExperiences();

  List<CapabilityGroup> getCapabilityGroups();

  List<String> getAllSkills();

  List<ContactAction> getContactActions();
}
