// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get title => '無限のダンジョン';

  @override
  String get startPrompt => 'ゲームを開始します。最初のシーンを描写してください。';

  @override
  String get inputHint => '何をしますか？';
}
