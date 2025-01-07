///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsFr implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsMainScreenFr mainScreen = _TranslationsMainScreenFr._(_root);
	@override Map<String, String> get locales => {
		'en': 'Anglais',
		'fr': 'Français',
	};
	@override String get notFound => 'Page introuvable';
	@override late final _TranslationsHomeScreenFr home_screen = _TranslationsHomeScreenFr._(_root);
}

// Path: mainScreen
class _TranslationsMainScreenFr implements TranslationsMainScreenEn {
	_TranslationsMainScreenFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Le titre français';
	@override String counter({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: 'Vous avez appuyé une fois.',
		other: 'Vous avez appuyé ${n} fois.',
	);
	@override String get tapMe => 'Appuyez-moi';
}

// Path: home_screen
class _TranslationsHomeScreenFr implements TranslationsHomeScreenEn {
	_TranslationsHomeScreenFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get home => 'D\'accueil';
	@override String get about => 'À propos de';
	@override String get resume => 'Reprendre';
	@override String get skills => 'Compétences';
	@override String get contact => 'Contacter';
	@override String get settings => 'Paramètres';
	@override String get myName => 'Hiu Tung Chan';
	@override String get iAm => 'Je suis';
	@override String get developer => 'Développeur';
	@override String get designer => 'Designer';
	@override String get freelancer => 'Pigiste';
	@override String get aboutTitle => 'Développeur Flutter et spécialiste des applications mobiles';
	@override String get aboutMeDescription => 'Développeur Flutter expérimenté avec 4 ans d\'expérience dans le développement d\'applications mobiles, fournissant des applications hautes performances centrées sur l\'utilisateur. Compétent dans la conception frontale, la mise en œuvre de fonctionnalités et l\'optimisation de l\'évolutivité pour répondre à divers objectifs commerciaux.';
	@override String get statistics => 'Statistiques';
	@override String get website => 'Site Web';
	@override String get phone => 'Numéro de téléphone';
	@override String get city => 'Ville';
	@override String get myCity => 'Toronto, ON, CA';
	@override String get degree => 'Degré';
	@override String get myDegree => 'Bachelor d\'ingénieur en génie informatique';
	@override String get email => 'Courriel';
	@override String get freelance => 'Indépendant';
	@override String get available => 'Disponible';
	@override String get happyClients => 'Clients satisfaits';
	@override String get projects => 'Projects';
	@override String get trainedStudent => 'Étudiants formés';
	@override String get hoursOfSupport => 'heures d\'assistance';
	@override String get view => 'vue';
	@override String get coreSkills => 'Compétences de base';
	@override String get allSkills => 'Toutes les compétences';
	@override String get french => 'Français';
	@override String get english => 'Anglais';
	@override String get themeMode => 'Mode thème';
	@override String get themeColor => 'Couleur du thème';
	@override String get language => 'Langue';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'mainScreen.title': return 'Le titre français';
			case 'mainScreen.counter': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
				one: 'Vous avez appuyé une fois.',
				other: 'Vous avez appuyé ${n} fois.',
			);
			case 'mainScreen.tapMe': return 'Appuyez-moi';
			case 'locales.en': return 'Anglais';
			case 'locales.fr': return 'Français';
			case 'notFound': return 'Page introuvable';
			case 'home_screen.home': return 'D\'accueil';
			case 'home_screen.about': return 'À propos de';
			case 'home_screen.resume': return 'Reprendre';
			case 'home_screen.skills': return 'Compétences';
			case 'home_screen.contact': return 'Contacter';
			case 'home_screen.settings': return 'Paramètres';
			case 'home_screen.myName': return 'Hiu Tung Chan';
			case 'home_screen.iAm': return 'Je suis';
			case 'home_screen.developer': return 'Développeur';
			case 'home_screen.designer': return 'Designer';
			case 'home_screen.freelancer': return 'Pigiste';
			case 'home_screen.aboutTitle': return 'Développeur Flutter et spécialiste des applications mobiles';
			case 'home_screen.aboutMeDescription': return 'Développeur Flutter expérimenté avec 4 ans d\'expérience dans le développement d\'applications mobiles, fournissant des applications hautes performances centrées sur l\'utilisateur. Compétent dans la conception frontale, la mise en œuvre de fonctionnalités et l\'optimisation de l\'évolutivité pour répondre à divers objectifs commerciaux.';
			case 'home_screen.statistics': return 'Statistiques';
			case 'home_screen.website': return 'Site Web';
			case 'home_screen.phone': return 'Numéro de téléphone';
			case 'home_screen.city': return 'Ville';
			case 'home_screen.myCity': return 'Toronto, ON, CA';
			case 'home_screen.degree': return 'Degré';
			case 'home_screen.myDegree': return 'Bachelor d\'ingénieur en génie informatique';
			case 'home_screen.email': return 'Courriel';
			case 'home_screen.freelance': return 'Indépendant';
			case 'home_screen.available': return 'Disponible';
			case 'home_screen.happyClients': return 'Clients satisfaits';
			case 'home_screen.projects': return 'Projects';
			case 'home_screen.trainedStudent': return 'Étudiants formés';
			case 'home_screen.hoursOfSupport': return 'heures d\'assistance';
			case 'home_screen.view': return 'vue';
			case 'home_screen.coreSkills': return 'Compétences de base';
			case 'home_screen.allSkills': return 'Toutes les compétences';
			case 'home_screen.french': return 'Français';
			case 'home_screen.english': return 'Anglais';
			case 'home_screen.themeMode': return 'Mode thème';
			case 'home_screen.themeColor': return 'Couleur du thème';
			case 'home_screen.language': return 'Langue';
			default: return null;
		}
	}
}

