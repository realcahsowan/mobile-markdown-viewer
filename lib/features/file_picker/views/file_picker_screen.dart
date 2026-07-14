import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../reader/views/reader_screen.dart';
import '../../editor/views/editor_screen.dart';
import '../providers/file_picker_provider.dart';

class FilePickerScreen extends ConsumerWidget {
  const FilePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileState = ref.watch(filePickerProvider);
    final theme = Theme.of(context);

    if (fileState.fileContent != null && fileState.filePath != null) {
      return HomeScreen(
        filePath: fileState.filePath!,
        fileName: fileState.fileName ?? 'Untitled',
        fileContent: fileState.fileContent!,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown Reader'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description_outlined,
                size: 80,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'No file opened',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Open a .md or .txt file to get started',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: fileState.isLoading
                    ? null
                    : () => ref.read(filePickerProvider.notifier).pickFile(),
                icon: fileState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.folder_open),
                label: Text(fileState.isLoading ? 'Opening...' : 'Open File'),
              ),
              if (fileState.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  fileState.error!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  final String filePath;
  final String fileName;
  final String fileContent;

  const HomeScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileContent,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String _content;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _content = widget.fileContent;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onContentChanged(String newContent) {
    setState(() => _content = newContent);
  }

  void _openNewFile() {
    ref.read(filePickerProvider.notifier).pickFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          _buildViewToggle(),
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            tooltip: 'Open another file',
            onPressed: _openNewFile,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          ReaderScreen(
            fileContent: _content,
            filePath: widget.filePath,
          ),
          EditorScreen(
            fileContent: _content,
            filePath: widget.filePath,
            onContentChanged: _onContentChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: SegmentedButton<int>(
        segments: const [
          ButtonSegment(
            value: 0,
            icon: Icon(Icons.visibility),
            tooltip: 'Preview',
          ),
          ButtonSegment(
            value: 1,
            icon: Icon(Icons.edit),
            tooltip: 'Source',
          ),
        ],
        selected: {_currentPage},
        onSelectionChanged: (set) {
          final page = set.first;
          _pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
