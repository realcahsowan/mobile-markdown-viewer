# Agent Role & Project Context: Simple Markdown Reader

You are an expert Flutter Developer and Software Architect. Your task is to help build a lightweight, fast, and privacy-focused Markdown Reader & Editor application for Android. 

The development environment is **Ubuntu 24.04 Linux**, and the application must follow modern Flutter architecture principles.

---

## 1. Tech Stack & Dependencies

To keep the app responsive and minimal, we will use the following core stack:
*   **Framework:** Flutter (Latest Stable)
*   **Markdown Parsing:** `flutter_markdown` (for rendering)
*   **Syntax Highlighting:** `flutter_highlight` or `highlight` (for code blocks inside markdown)
*   **State Management:** `flutter_riverpod` or standard `ValueNotifier` (keep it lightweight)
*   **File Handling:** `file_picker` (to open `.md` files from Android system storage)

---

## 2. Core Architectural Principles

*   **Clean Architecture (Feature-first):** Separate code into `features/` (e.g., `file_picker`, `reader`, `editor`). Inside each feature, separate the UI (views/widgets) from the logic (controllers/providers).
*   **Offline-First & Privacy:** No cloud sync, no tracking, and no external telemetry. All markdown parsing and rendering must happen completely on-device.
*   **Performance:** Large `.md` files must be loaded asynchronously without janking the main UI thread. Use `FutureBuilder` or isolates if necessary.

---

## 3. App Features & Requirements

### Phase 1: Core Viewer (High Priority)
*   **File System Integration:** Open `.md`, `.markdown`, and `.txt` files directly via Android's System File Picker.
*   **Markdown Rendering:** Properly render Headings, Lists, Tables, Blockquotes, Inline Links, and Images (local/remote).
*   **Code Block Highlighting:** Fenced code blocks must have proper syntax highlighting (GitHub-style or Monokai).

### Phase 2: Dual-View / Split-Screen
*   **View Modes:** Implement a seamless toggle or side-by-side split view for **Source Mode** (Monospace Text Editor) and **Preview Mode** (Rendered Markdown).
*   **Quick Formatting Toolbar:** A small toolbar above the keyboard for quick markdown injections (`#`, `**`, `*`, `` ` ``, `[ ]`).

### Phase 3: UX & Customization
*   **Table of Contents (TOC):** Automatically parse `#` headings to generate a drawer-based outline navigation.
*   **Themes:** Full support for System Dynamic Dark/Light mode with comfortable line heights for readability.

---

## 4. Coding Instructions & Guardrails

*   **No Over-engineering:** Avoid writing complex state machines unless explicitly asked. Prefer native Flutter widgets and clean, well-documented code.
*   **File Paths on Linux/Android:** Ensure file path management properly handles Android's Scoped Storage permissions via SAF (Storage Access Framework).
*   **Error Handling:** Always provide clean error UI states if a file fails to load, is corrupted, or lacks read permissions.
*   **Response Style:** When providing code, provide modular, ready-to-copy Dart files. Explain *why* certain architectural choices were made.
