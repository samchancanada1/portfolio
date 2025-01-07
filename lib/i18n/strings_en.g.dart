///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final TranslationsMainScreenEn mainScreen = TranslationsMainScreenEn._(_root);
	Map<String, String> get locales => {
		'en': 'English',
		'fr': 'French',
	};
	String get notFound => 'Page Not Found';
	late final TranslationsHomeScreenEn home_screen = TranslationsHomeScreenEn._(_root);
}

// Path: mainScreen
class TranslationsMainScreenEn {
	TranslationsMainScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'An English Title';
	String counter({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'You pressed ${n} time.',
		other: 'You pressed ${n} times.',
	);
	String get tapMe => 'Tap me';
}

// Path: home_screen
class TranslationsHomeScreenEn {
	TranslationsHomeScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get about => 'About';
	String get resume => 'Resume';
	String get skills => 'Skills';
	String get contact => 'Contact';
	String get settings => 'Settings';
	String get myName => 'Hiu Tung Chan';
	String get iAm => 'I am ';
	String get developer => 'Developer';
	String get designer => 'Designer';
	String get freelancer => 'Freelancer';
	String get aboutTitle => 'Flutter Developer and Mobile Application Specialist';
	String get aboutMeDescription => 'Experienced Flutter Developer with 4 years of mobile application development, delivering user-centric, high-performance apps. Skilled in front-end design, feature implementation, and optimizing scalability to meet diverse business objectives.';
	String get statistics => 'Statistics';
	String get website => 'Website';
	String get phone => 'Phone number';
	String get city => 'City';
	String get myCity => 'Toronto, ON, CA';
	String get degree => 'Degree';
	String get myDegree => 'Bachelor of Engineering in Computer Engineering';
	String get email => 'E-mail';
	String get freelance => 'Freelance';
	String get available => 'Available';
	String get happyClients => 'Happy clients';
	String get projects => 'Projects';
	String get trainedStudent => 'Trained students';
	String get hoursOfSupport => 'Hours of support';
	String get view => 'view';
	String get coreSkills => 'Core skills';
	String get allSkills => 'All skills';
	String get french => 'French';
	String get english => 'English';
	String get themeMode => 'Theme Mode';
	String get themeColor => 'Theme Color';
	String get language => 'Language';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'mainScreen.title': return 'An English Title';
			case 'mainScreen.counter': return ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
				one: 'You pressed ${n} time.',
				other: 'You pressed ${n} times.',
			);
			case 'mainScreen.tapMe': return 'Tap me';
			case 'locales.en': return 'English';
			case 'locales.fr': return 'French';
			case 'notFound': return 'Page Not Found';
			case 'home_screen.home': return 'Home';
			case 'home_screen.about': return 'About';
			case 'home_screen.resume': return 'Resume';
			case 'home_screen.skills': return 'Skills';
			case 'home_screen.contact': return 'Contact';
			case 'home_screen.settings': return 'Settings';
			case 'home_screen.myName': return 'Hiu Tung Chan';
			case 'home_screen.iAm': return 'I am ';
			case 'home_screen.developer': return 'Developer';
			case 'home_screen.designer': return 'Designer';
			case 'home_screen.freelancer': return 'Freelancer';
			case 'home_screen.aboutTitle': return 'Flutter Developer and Mobile Application Specialist';
			case 'home_screen.aboutMeDescription': return 'Experienced Flutter Developer with 4 years of mobile application development, delivering user-centric, high-performance apps. Skilled in front-end design, feature implementation, and optimizing scalability to meet diverse business objectives.';
			case 'home_screen.statistics': return 'Statistics';
			case 'home_screen.website': return 'Website';
			case 'home_screen.phone': return 'Phone number';
			case 'home_screen.city': return 'City';
			case 'home_screen.myCity': return 'Toronto, ON, CA';
			case 'home_screen.degree': return 'Degree';
			case 'home_screen.myDegree': return 'Bachelor of Engineering in Computer Engineering';
			case 'home_screen.email': return 'E-mail';
			case 'home_screen.freelance': return 'Freelance';
			case 'home_screen.available': return 'Available';
			case 'home_screen.happyClients': return 'Happy clients';
			case 'home_screen.projects': return 'Projects';
			case 'home_screen.trainedStudent': return 'Trained students';
			case 'home_screen.hoursOfSupport': return 'Hours of support';
			case 'home_screen.view': return 'view';
			case 'home_screen.coreSkills': return 'Core skills';
			case 'home_screen.allSkills': return 'All skills';
			case 'home_screen.french': return 'French';
			case 'home_screen.english': return 'English';
			case 'home_screen.themeMode': return 'Theme Mode';
			case 'home_screen.themeColor': return 'Theme Color';
			case 'home_screen.language': return 'Language';
			default: return null;
		}
	}
}

