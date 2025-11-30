import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en'); // Default to English
  }

  void setLocale(Locale locale) {
    state = locale;
  }
}

// Helper to get readable language name for AI
String getLanguageName(Locale locale) {
  switch (locale.languageCode) {
    case 'ko':
      return 'Korean';
    case 'ja':
      return 'Japanese';
    default:
      return 'English';
  }
}
