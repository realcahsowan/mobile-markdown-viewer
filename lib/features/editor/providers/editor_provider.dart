import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorState {
  final String content;
  final bool isDirty;
  final bool isSaving;
  final String? error;

  const EditorState({
    this.content = '',
    this.isDirty = false,
    this.isSaving = false,
    this.error,
  });

  EditorState copyWith({
    String? content,
    bool? isDirty,
    bool? isSaving,
    String? error,
  }) {
    return EditorState(
      content: content ?? this.content,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier() : super(const EditorState());

  void init(String content) {
    if (state.content != content) {
      state = EditorState(content: content);
    }
  }

  void updateContent(String newContent) {
    state = state.copyWith(content: newContent, isDirty: true);
  }

  Future<void> saveToFile(String filePath) async {
    if (!state.isDirty) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await File(filePath).writeAsString(state.content);
      state = state.copyWith(isSaving: false, isDirty: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final editorProvider =
    StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier();
});
