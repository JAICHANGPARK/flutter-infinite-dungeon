// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get title => '무한의 던전';

  @override
  String get startPrompt => '게임을 시작해. 첫 장면을 묘사해줘.';

  @override
  String get inputHint => '무엇을 하시겠습니까?';
}
