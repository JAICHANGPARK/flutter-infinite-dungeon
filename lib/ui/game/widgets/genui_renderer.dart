import 'package:flutter/material.dart';

/// A simple implementation of GenUI renderer following the pattern of
/// server-driven (or AI-driven) UI.
///
/// It expects a JSON structure representing a widget tree.
/// Supported types: 'column', 'row', 'text', 'button', 'input'.
class GenUiRenderer extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String) onAction;

  const GenUiRenderer({super.key, required this.data, required this.onAction});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return _buildWidget(data);
  }

  Widget _buildWidget(Map<String, dynamic> widgetData) {
    final type = widgetData['type'] as String?;

    switch (type) {
      case 'column':
        return Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: (widgetData['children'] as List<dynamic>? ?? [])
              .map((child) => _buildWidget(child as Map<String, dynamic>))
              .toList(),
        );
      case 'row':
        return Wrap(
          // Use Wrap instead of Row for safety
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: (widgetData['children'] as List<dynamic>? ?? [])
              .map((child) => _buildWidget(child as Map<String, dynamic>))
              .toList(),
        );
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            widgetData['content'] ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        );
      case 'button':
        return ElevatedButton(
          onPressed: () => onAction(widgetData['action'] ?? ''),
          child: Text(widgetData['label'] ?? 'Button'),
        );
      case 'input':
        return _GenUiInput(hint: widgetData['hint'], onAction: onAction);
      default:
        // If unknown, try to render children if any, or nothing
        return const SizedBox.shrink();
    }
  }
}

class _GenUiInput extends StatefulWidget {
  final String? hint;
  final Function(String) onAction;

  const _GenUiInput({this.hint, required this.onAction});

  @override
  State<_GenUiInput> createState() => _GenUiInputState();
}

class _GenUiInputState extends State<_GenUiInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hint ?? "...",
                filled: true,
                fillColor: Colors.white70,
              ),
              onSubmitted: (value) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: _submit),
        ],
      ),
    );
  }

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onAction(_controller.text);
      _controller.clear();
    }
  }
}
