import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_constants.dart';

class FilePickerState {
  final String? filePath;
  final String? fileName;
  final String? fileContent;
  final bool isLoading;
  final String? error;

  const FilePickerState({
    this.filePath,
    this.fileName,
    this.fileContent,
    this.isLoading = false,
    this.error,
  });

  FilePickerState copyWith({
    String? filePath,
    String? fileName,
    String? fileContent,
    bool? isLoading,
    String? error,
  }) {
    return FilePickerState(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileContent: fileContent ?? this.fileContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FilePickerNotifier extends StateNotifier<FilePickerState> {
  FilePickerNotifier() : super(const FilePickerState());

  Future<void> pickFile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedExtensions
            .map((e) => e.replaceFirst('.', ''))
            .toList(),
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final file = result.files.first;
      final path = file.path;

      if (path == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Could not access file path',
        );
        return;
      }

      final content = await File(path).readAsString();

      state = FilePickerState(
        filePath: path,
        fileName: file.name,
        fileContent: content,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to open file: ${e.toString()}',
      );
    }
  }

  void clear() {
    state = const FilePickerState();
  }
}

final filePickerProvider =
    StateNotifierProvider<FilePickerNotifier, FilePickerState>((ref) {
  return FilePickerNotifier();
});
