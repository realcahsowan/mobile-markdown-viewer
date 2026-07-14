import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/editor_provider.dart';
import '../widgets/formatting_toolbar.dart';
import '../widgets/source_editor.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String fileContent;
  final String filePath;
  final void Function(String) onContentChanged;

  const EditorScreen({
    super.key,
    required this.fileContent,
    required this.filePath,
    required this.onContentChanged,
  });

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late TextEditingController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fileContent);
  }

  @override
  void didUpdateWidget(EditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filePath != oldWidget.filePath) {
      _controller.text = widget.fileContent;
      _initialized = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    ref.read(editorProvider.notifier).updateContent(text);
    widget.onContentChanged(text);
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _controller.text;
    final selection = _controller.selection;
    final selectedText = selection.isValid
        ? text.substring(selection.start, selection.end)
        : '';

    final newText = selectedText.isEmpty
        ? '${text.substring(0, selection.start)}$prefix$suffix${text.substring(selection.end)}'
        : text.replaceRange(
            selection.start, selection.end, '$prefix$selectedText$suffix');

    _controller.text = newText;
    _onTextChanged(newText);

    final cursorPos = selection.start +
        prefix.length +
        (selectedText.isEmpty ? 0 : selectedText.length);
    _controller.selection = TextSelection.collapsed(offset: cursorPos);
  }

  Future<void> _saveFile() async {
    final notifier = ref.read(editorProvider.notifier);
    await notifier.saveToFile(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      ref.read(editorProvider.notifier).init(widget.fileContent);
      _initialized = true;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final editorState = ref.watch(editorProvider);

    return Column(
      children: [
        FormattingToolbar(onFormat: _insertFormatting),
        Expanded(
          child: Stack(
            children: [
              SourceEditor(
                controller: _controller,
                isDark: isDark,
              ),
              if (editorState.isSaving)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        if (editorState.error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    editorState.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () =>
                      ref.read(editorProvider.notifier).clearError(),
                ),
              ],
            ),
          ),
        if (editorState.isDirty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Unsaved changes',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _saveFile,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
