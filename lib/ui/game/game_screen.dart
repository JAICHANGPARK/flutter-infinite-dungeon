import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/game_turn.dart';
import 'view_model/game_view_model.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      ref.read(gameViewModelProvider.notifier).startGame(l10n.startPrompt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModelNotifier = ref.read(gameViewModelProvider.notifier);
    // Ensure we watch the state to rebuild if necessary (e.g. for loading overlay if we added one)
    final gameState = ref.watch(gameViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Infinite Dungeon'),
        backgroundColor: Colors.black,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library, color: Colors.white),
            onPressed: () {
              _showImageGallery(context, gameState);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: 'New Game',
            onPressed: () {
              _showNewGameDialog(context);
            },
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (Locale locale) {
              ref.read(localeProvider.notifier).setLocale(locale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ko'),
                child: Text('한국어'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ja'),
                child: Text('日本語'),
              ),
            ],
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  'Chronicles',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gameState.turns.length,
                itemBuilder: (context, index) {
                  final reversedIndex = gameState.turns.length - 1 - index;
                  final turn = gameState.turns[reversedIndex];

                  return ListTile(
                    leading: turn.imageData != null
                        ? Image.memory(
                            turn.imageData!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                          ),
                    title: Text(
                      'Turn ${reversedIndex + 1}: ${turn.userAction}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      turn.storyText,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.restore,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        viewModelNotifier.restoreTurn(turn);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Image Area with Prompt Overlay
          Container(
            width: double.infinity,
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: gameState.isGeneratingImage
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Generating scene...',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : gameState.currentImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          gameState.currentImage!,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                        if (gameState.currentImagePrompt != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                gameState.currentImagePrompt!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Icon(Icons.image, color: Colors.white24, size: 48),
                    ),
            ),
          ),
          // GenUI Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: GenUiSurface(
                      host: viewModelNotifier.genUiManager,
                      surfaceId: 'main_game',
                      defaultBuilder: (context) => const Center(
                        child: Text(
                          'Waiting for the Dungeon Master...',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  // Loading indicator when text is being generated
                  if (gameState.isGeneratingText)
                    const Positioned(
                      bottom: 20,
                      right: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageGallery(BuildContext context, GameState gameState) {
    final imagesWithPrompts = gameState.turns
        .where((turn) => turn.imageData != null)
        .toList()
        .reversed
        .toList();

    if (imagesWithPrompts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No images generated yet')));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Image Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${imagesWithPrompts.length} images',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: imagesWithPrompts.length,
                itemBuilder: (context, index) {
                  final turn = imagesWithPrompts[index];
                  return GestureDetector(
                    onTap: () {
                      _showFullImage(context, turn);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(turn.imageData!, fit: BoxFit.cover),
                          if (turn.imagePrompt != null)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.9),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  turn.imagePrompt!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Start New Game?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will clear your current progress and return to the settings screen. Are you sure?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              // Clear game state before navigating
              await ref.read(gameViewModelProvider.notifier).clearGameState();
              // Navigate back to SettingsScreen and clear the stack
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/settings');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, GameTurn turn) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 600),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(turn.imageData!, fit: BoxFit.contain),
              ),
            ),
            if (turn.imagePrompt != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prompt:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      turn.imagePrompt!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
