import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reader_provider.dart';
import '../widgets/markdown_viewer.dart';
import '../widgets/toc_drawer.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String fileContent;
  final String filePath;

  const ReaderScreen({
    super.key,
    required this.fileContent,
    required this.filePath,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(readerProvider.notifier).updateToc(widget.fileContent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToHeading(String heading) {
    final index = widget.fileContent.indexOf('## $heading');
    if (index == -1) return;

    final before = widget.fileContent.substring(0, index);
    final lineNumber = '\n'.allMatches(before).length;

    final estimatedOffset = lineNumber * 24.0;
    _scrollController.animateTo(
      estimatedOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final readerState = ref.watch(readerProvider);

    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (_) {
          Scaffold.of(context).openDrawer();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: MarkdownViewer(
            data: widget.fileContent,
            filePath: widget.filePath,
          ),
        ),
      ),
      drawer: TocDrawer(
        headings: readerState.tocHeadings,
        onTap: _scrollToHeading,
      ),
    );
  }
}
