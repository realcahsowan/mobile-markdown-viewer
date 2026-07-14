import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import '../../../core/theme/app_colors.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String? language;
  final bool isDark;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDark ? draculaTheme : githubTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceContainerDark : AppColors.surfaceContainerLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.borderDark.withValues(alpha: 0.3)
                    : AppColors.borderLight,
              ),
              child: Text(
                language!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              code.trimRight(),
              language: language ?? 'plaintext',
              theme: theme,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
