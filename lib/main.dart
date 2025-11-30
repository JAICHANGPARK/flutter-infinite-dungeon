import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'ui/settings/settings_screen.dart';

void main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint(
      "Warning: .env file not found or invalid. Make sure to create one.",
    );
  }

  runApp(const ProviderScope(child: InfiniteDungeonApp()));
}

class InfiniteDungeonApp extends ConsumerWidget {
  const InfiniteDungeonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Infinite Dungeon',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
        Locale('ja'), // Japanese
      ],
      locale: currentLocale,
      home: const SettingsScreen(),
      routes: {'/settings': (context) => const SettingsScreen()},
    );
  }
}
