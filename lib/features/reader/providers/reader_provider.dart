import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderState {
  final List<String> tocHeadings;
  final String? selectedHeading;

  const ReaderState({
    this.tocHeadings = const [],
    this.selectedHeading,
  });

  ReaderState copyWith({
    List<String>? tocHeadings,
    String? selectedHeading,
  }) {
    return ReaderState(
      tocHeadings: tocHeadings ?? this.tocHeadings,
      selectedHeading: selectedHeading,
    );
  }
}

class ReaderNotifier extends StateNotifier<ReaderState> {
  ReaderNotifier() : super(const ReaderState());

  List<String> parseToc(String markdown) {
    final headings = <String>[];
    final lines = markdown.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('##')) {
        headings.add(trimmed.replaceAll('#', '').trim());
      }
    }
    return headings;
  }

  void updateToc(String markdown) {
    state = state.copyWith(tocHeadings: parseToc(markdown));
  }
}

final readerProvider = StateNotifierProvider<ReaderNotifier, ReaderState>((ref) {
  return ReaderNotifier();
});
