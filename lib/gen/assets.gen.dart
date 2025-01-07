/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/not-found.json
  String get notFound => 'assets/animations/not-found.json';

  /// List of all assets
  List<String> get values => [notFound];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/cloack.svg
  String get cloack => 'assets/icons/cloack.svg';

  /// File path: assets/icons/cv_icon.svg
  String get cvIcon => 'assets/icons/cv_icon.svg';

  /// File path: assets/icons/email_icon.png
  AssetGenImage get emailIcon =>
      const AssetGenImage('assets/icons/email_icon.png');

  /// File path: assets/icons/github_logo.png
  AssetGenImage get githubLogo =>
      const AssetGenImage('assets/icons/github_logo.png');

  /// File path: assets/icons/linkedin_icon.png
  AssetGenImage get linkedinIcon =>
      const AssetGenImage('assets/icons/linkedin_icon.png');

  /// File path: assets/icons/mall_icon.svg
  String get mallIcon => 'assets/icons/mall_icon.svg';

  /// File path: assets/icons/pos_icon.svg
  String get posIcon => 'assets/icons/pos_icon.svg';

  /// File path: assets/icons/projects-list.svg
  String get projectsList => 'assets/icons/projects-list.svg';

  /// File path: assets/icons/stackoverflow_icon.png
  AssetGenImage get stackoverflowIcon =>
      const AssetGenImage('assets/icons/stackoverflow_icon.png');

  /// File path: assets/icons/users.svg
  String get users => 'assets/icons/users.svg';

  /// File path: assets/icons/vr_icon.svg
  String get vrIcon => 'assets/icons/vr_icon.svg';

  /// File path: assets/icons/whatsapp_logo.png
  AssetGenImage get whatsappLogo =>
      const AssetGenImage('assets/icons/whatsapp_logo.png');

  /// File path: assets/icons/youtube_logo.png
  AssetGenImage get youtubeLogo =>
      const AssetGenImage('assets/icons/youtube_logo.png');

  /// List of all assets
  List<dynamic> get values => [
        cloack,
        cvIcon,
        emailIcon,
        githubLogo,
        linkedinIcon,
        mallIcon,
        posIcon,
        projectsList,
        stackoverflowIcon,
        users,
        vrIcon,
        whatsappLogo,
        youtubeLogo
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/cv_image.png
  AssetGenImage get cvImage =>
      const AssetGenImage('assets/images/cv_image.png');

  /// File path: assets/images/home-background.jpg
  AssetGenImage get homeBackground =>
      const AssetGenImage('assets/images/home-background.jpg');

  /// File path: assets/images/mall_image.png
  AssetGenImage get mallImage =>
      const AssetGenImage('assets/images/mall_image.png');

  /// File path: assets/images/pos_image.png
  AssetGenImage get posImage =>
      const AssetGenImage('assets/images/pos_image.png');

  /// File path: assets/images/profile-image.jpg
  AssetGenImage get profileImage =>
      const AssetGenImage('assets/images/profile-image.jpg');

  /// File path: assets/images/small-home-bg.jpg
  AssetGenImage get smallHomeBg =>
      const AssetGenImage('assets/images/small-home-bg.jpg');

  /// File path: assets/images/splash.jpg
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.jpg');

  /// File path: assets/images/tung-logo.svg
  String get tungLogo => 'assets/images/tung-logo.svg';

  /// File path: assets/images/vr_image.png
  AssetGenImage get vrImage =>
      const AssetGenImage('assets/images/vr_image.png');

  /// List of all assets
  List<dynamic> get values => [
        cvImage,
        homeBackground,
        mallImage,
        posImage,
        profileImage,
        smallHomeBg,
        splash,
        tungLogo,
        vrImage
      ];
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const String pubspec = 'pubspec.yaml';

  /// List of all assets
  static List<String> get values => [pubspec];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
