import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TocDrawer extends StatelessWidget {
  final List<String> headings;
  final void Function(String heading) onTap;

  const TocDrawer({
    super.key,
    required this.headings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Text(
              'Table of Contents',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (headings.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No headings found'),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: headings.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final heading = headings[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.tag,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      heading,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      onTap(heading);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
