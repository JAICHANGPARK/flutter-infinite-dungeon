import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

// =============================================================================
// 1. Schemas
// =============================================================================

final _statusSchema = S.object(
  properties: {
    'hp': S.integer(),
    'maxHp': S.integer(),
    'mp': S.integer(),
    'maxMp': S.integer(),
    'level': S.integer(),
    'name': S.string(),
  },
  required: ['hp', 'maxHp', 'mp', 'maxMp', 'level', 'name'],
);

final _monsterSchema = S.object(
  properties: {'name': S.string(), 'hp': S.integer(), 'maxHp': S.integer()},
  required: ['name', 'hp', 'maxHp'],
);

final _storyImageSchema = S.object(
  properties: {'prompt': S.string(), 'imageData': S.string()},
  required: ['prompt'],
);

final _textSchema = S.object(
  properties: {'text': S.string()},
  required: ['text'],
);

// =============================================================================
// 2. Widgets
// =============================================================================

class StatusWidget extends StatelessWidget {
  final int hp, maxHp, mp, maxMp, level;
  final String name;

  const StatusWidget({
    super.key,
    required this.hp,
    required this.maxHp,
    required this.mp,
    required this.maxMp,
    required this.level,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Lv. $level", style: const TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 8),
            _buildBar("HP", hp, maxHp, Colors.redAccent),
            const SizedBox(height: 4),
            _buildBar("MP", mp, maxMp, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, int current, int max, Color color) {
    final pct = (max == 0) ? 0.0 : (current / max).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Colors.black45,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$current/$max",
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }
}

class MonsterWidget extends StatelessWidget {
  final String name;
  final int hp, maxHp;

  const MonsterWidget({
    super.key,
    required this.name,
    required this.hp,
    required this.maxHp,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (maxHp == 0) ? 0.0 : (hp / maxHp).clamp(0.0, 1.0);
    return Card(
      color: Colors.black.withValues(alpha: 0.5),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.yellow,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.black54,
              color: Colors.red,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 4),
            Text(
              "$hp / $maxHp",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryImageWidget extends StatelessWidget {
  final String prompt;
  final Uint8List? imageData;

  const StoryImageWidget({super.key, required this.prompt, this.imageData});

  @override
  Widget build(BuildContext context) {
    if (prompt.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageData != null
              ? Image.memory(
                  imageData!,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, color: Colors.white24, size: 48),
                      const SizedBox(height: 8),
                      const Text(
                        'Generating scene...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3. Catalog Items
// =============================================================================

final statusCatalogItem = CatalogItem(
  name: 'StatusWidget',
  dataSchema: _statusSchema,
  widgetBuilder: (context) {
    final data = context.data as Map<String, dynamic>;
    final hp = context.dataContext.subscribeToValue<int>(
      data['hp'],
      'literalNumber',
    );
    final maxHp = context.dataContext.subscribeToValue<int>(
      data['maxHp'],
      'literalNumber',
    );
    final mp = context.dataContext.subscribeToValue<int>(
      data['mp'],
      'literalNumber',
    );
    final maxMp = context.dataContext.subscribeToValue<int>(
      data['maxMp'],
      'literalNumber',
    );
    final level = context.dataContext.subscribeToValue<int>(
      data['level'],
      'literalNumber',
    );
    final name = context.dataContext.subscribeToString(data['name']);

    return AnimatedBuilder(
      animation: Listenable.merge([hp, maxHp, mp, maxMp, level, name]),
      builder: (ctx, _) => StatusWidget(
        hp: hp.value ?? 0,
        maxHp: maxHp.value ?? 100,
        mp: mp.value ?? 0,
        maxMp: maxMp.value ?? 50,
        level: level.value ?? 1,
        name: name.value ?? 'Hero',
      ),
    );
  },
);

final monsterCatalogItem = CatalogItem(
  name: 'MonsterWidget',
  dataSchema: _monsterSchema,
  widgetBuilder: (context) {
    final data = context.data as Map<String, dynamic>;
    final name = context.dataContext.subscribeToString(data['name']);
    final hp = context.dataContext.subscribeToValue<int>(
      data['hp'],
      'literalNumber',
    );
    final maxHp = context.dataContext.subscribeToValue<int>(
      data['maxHp'],
      'literalNumber',
    );

    return AnimatedBuilder(
      animation: Listenable.merge([name, hp, maxHp]),
      builder: (ctx, _) => MonsterWidget(
        name: name.value ?? 'Unknown',
        hp: hp.value ?? 0,
        maxHp: maxHp.value ?? 100,
      ),
    );
  },
);

final storyImageCatalogItem = CatalogItem(
  name: 'StoryImage',
  dataSchema: _storyImageSchema,
  widgetBuilder: (context) {
    final data = context.data as Map<String, dynamic>;
    final prompt = context.dataContext.subscribeToString(data['prompt']);
    final imgData = context.dataContext.subscribeToString(data['imageData']);
    return AnimatedBuilder(
      animation: Listenable.merge([prompt, imgData]),
      builder: (ctx, _) {
        Uint8List? bytes;
        if (imgData.value != null) {
          try {
            bytes = base64Decode(imgData.value!);
          } catch (_) {}
        }
        return StoryImageWidget(prompt: prompt.value ?? '', imageData: bytes);
      },
    );
  },
);

final textCatalogItem = CatalogItem(
  name: 'Text',
  dataSchema: _textSchema,
  widgetBuilder: (context) {
    // [수정] context.data를 Map으로 명시적 캐스팅
    final data = context.data as Map<String, dynamic>;
    final text = context.dataContext.subscribeToString(data['text']);

    return ValueListenableBuilder(
      valueListenable: text,
      builder: (_, val, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SelectableText(
          val ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  },
);

final dungeonCatalog = Catalog([
  CoreCatalogItems.column,
  CoreCatalogItems.row,
  CoreCatalogItems.button,
  CoreCatalogItems.textField,
  textCatalogItem,
  statusCatalogItem,
  storyImageCatalogItem,
  monsterCatalogItem,
]);
