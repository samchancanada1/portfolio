import '../entities/portfolio_content.dart';
import '../repositories/portfolio_repository.dart';

class GetHomeContentUseCase {
  const GetHomeContentUseCase(this._repository);

  final PortfolioRepository _repository;

  HomeContent call() {
    return HomeContent(
      hero: _repository.getHeroProfile(),
      about: _repository.getAboutProfile(),
      coreCompetencies: _repository.getCoreCompetencies(),
      skillsOverview: _repository.getSkillsOverview(),
      designLenses: _repository.getDesignLenses(),
      stats: _repository.getStats(),
      experiences: _repository.getExperiences(),
      capabilityGroups: _repository.getCapabilityGroups(),
      allSkills: _repository.getAllSkills(),
      contactActions: _repository.getContactActions(),
    );
  }
}
