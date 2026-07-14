import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/languages/all.dart' show allLanguages;
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:markdown/markdown.dart' as md;
import 'code_block.dart';

class MarkdownViewer extends StatelessWidget {
  final String data;
  final String filePath;

  const MarkdownViewer({
    super.key,
    required this.data,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Markdown(
      data: data,
      selectable: true,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
          height: 1.4,
        ),
        h2: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
          height: 1.4,
        ),
        h3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
          height: 1.4,
        ),
        p: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        listBullet: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isDark ? Colors.amber.shade300 : Colors.amber.shade700,
              width: 4,
            ),
          ),
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
        blockquotePadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        code: TextStyle(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          fontFamily: 'monospace',
          fontSize: 14,
          color: isDark ? Colors.amber.shade200 : Colors.deepPurple,
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        tableBorder: TableBorder.all(
          color: isDark ? Colors.white24 : Colors.black26,
          width: 1,
        ),
        tableHead: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
        tableBody: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white24 : Colors.black12,
              width: 2,
            ),
          ),
        ),
        a: TextStyle(
          color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
          decoration: TextDecoration.underline,
        ),
      ),
      imageBuilder: (uri, title, alt) {
        if (uri.toString().startsWith('http')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                uri.toString(),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: isDark ? Colors.white12 : Colors.black12,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      builders: {
        'code': CodeBlockBuilder(isDark: isDark),
      },
    );
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  final bool isDark;

  CodeBlockBuilder({required this.isDark});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final language = element.attributes['class']?.replaceAll('language-', '');
    final code = element.textContent;

    return CodeBlockWidget(
      code: code,
      language: language,
      isDark: isDark,
    );
  }
}
