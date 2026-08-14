import '../entities/portfolio_content.dart';

abstract class PortfolioRepository {
  List<DesignLens> getDesignLenses();

  List<PortfolioStat> getStats();

  List<Experience> getExperiences();

  List<CapabilityGroup> getCapabilityGroups();

  List<String> getAllSkills();

  List<ContactAction> getContactActions();
}
