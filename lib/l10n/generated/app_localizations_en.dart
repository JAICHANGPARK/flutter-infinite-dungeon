// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Infinite Dungeon';

  @override
  String get startPrompt => 'Start the game. Describe the initial scene.';

  @override
  String get inputHint => 'What do you want to do?';
}
