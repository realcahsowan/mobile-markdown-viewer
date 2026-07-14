class AppConstants {
  AppConstants._();

  static const List<String> supportedExtensions = [
    '.md',
    '.markdown',
    '.mdown',
    '.txt',
  ];

  static const String defaultMarkdownSample = '''# Welcome to Markdown Reader

Start by opening a **.md** file using the file picker.

## Features
- Full Markdown Rendering
- Syntax Highlighted Code Blocks
- Dark & Light Theme
- Table of Contents
- Source / Preview Split View
''';
}
