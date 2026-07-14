# Markdown Reader

A lightweight, fast, and privacy-focused Markdown Reader & Editor for Android.

## Features

- **File System Integration** — Open `.md`, `.markdown`, and `.txt` files via Android's System File Picker
- **Markdown Rendering** — Headings, Lists, Tables, Blockquotes, Links, and Images (local/remote)
- **Syntax Highlighting** — Fenced code blocks with GitHub-style or Dracula themes
- **Dual-View Mode** — Toggle between Preview (rendered) and Source (editor) views
- **Formatting Toolbar** — Quick markdown injections (`#`, `**`, `*`, `` ` ``, `[]`, `![]()`)
- **Table of Contents** — Auto-generated outline from `##` headings via drawer
- **Dark/Light Theme** — Follows system dynamic theme
- **Offline-First** — All parsing and rendering happens on-device. No tracking, no telemetry.

## Tech Stack

| Dependency | Purpose |
|---|---|
| `flutter_markdown` | Markdown rendering |
| `flutter_highlight` / `highlight` | Code block syntax highlighting |
| `flutter_riverpod` | State management |
| `file_picker` | Android file system access |

## Project Structure

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp + theme config
├── core/
│   ├── theme/app_colors.dart          # Color palette
│   ├── theme/app_theme.dart           # Light/Dark ThemeData
│   └── constants/app_constants.dart   # Supported extensions, defaults
└── features/
    ├── file_picker/                   # File selection logic
    │   ├── providers/
    │   └── views/
    ├── reader/                        # Markdown preview
    │   ├── providers/
    │   ├── widgets/                   # MarkdownViewer, CodeBlock, TocDrawer
    │   └── views/
    └── editor/                        # Source code editor
        ├── providers/
        ├── widgets/                   # SourceEditor, FormattingToolbar
        └── views/
```

## Build

```bash
flutter pub get
flutter build apk --release --split-per-abi
```

APK outputs are in `build/app/outputs/flutter-apk/`.

## CI/CD

GitHub Actions workflow in `.github/workflows/build.yml` automatically builds APK and App Bundle on every push to `main`/`master`.

## License

Private project.
