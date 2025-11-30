import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_config_provider.dart';
import '../../providers/locale_provider.dart';
import '../game/game_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiKeyController;
  late TextEditingController _nameController;
  late TextEditingController _classController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(gameConfigProvider);
    _apiKeyController = TextEditingController(text: config.apiKey);
    _nameController = TextEditingController(text: config.characterName);
    _classController = TextEditingController(text: config.characterClass);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _nameController.dispose();
    _classController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      ref.read(gameConfigProvider.notifier).setApiKey(_apiKeyController.text);
      ref
          .read(gameConfigProvider.notifier)
          .setCharacterName(_nameController.text);
      ref
          .read(gameConfigProvider.notifier)
          .setCharacterClass(_classController.text);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Game Settings'),
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/title_poster.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            color: Colors.black26,
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 200,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const Text(
                  //   'Welcome to Infinite Dungeon',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 32),

                  // API Key Input
                  TextFormField(
                    controller: _apiKeyController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Gemini API Key',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      helperText: 'Leave empty to use .env key',
                      helperStyle: TextStyle(color: Colors.white38),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Language Selection
                  DropdownButtonFormField<Locale>(
                    initialValue: currentLocale,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem(value: Locale('ko'), child: Text('한국어')),
                      DropdownMenuItem(value: Locale('ja'), child: Text('日本語')),
                    ],
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        ref.read(localeProvider.notifier).setLocale(newLocale);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Character Name
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Character Name',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Character Class
                  TextFormField(
                    controller: _classController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Character Class / Description',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      helperText: 'e.g. "Ranger", "Wizard", "A brave knight"',
                      helperStyle: TextStyle(color: Colors.white38),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a class or description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),

                  // Start Button
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start Adventure',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
