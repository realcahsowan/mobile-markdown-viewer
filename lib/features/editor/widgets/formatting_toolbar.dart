import 'package:flutter/material.dart';

class FormattingToolbar extends StatelessWidget {
  final void Function(String prefix, String suffix) onFormat;

  const FormattingToolbar({super.key, required this.onFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading',
            onTap: () => onFormat('# ', ''),
          ),
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            onTap: () => onFormat('**', '**'),
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            onTap: () => onFormat('*', '*'),
          ),
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet list',
            onTap: () => onFormat('- ', ''),
          ),
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered list',
            onTap: () => onFormat('1. ', ''),
          ),
          _ToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Blockquote',
            onTap: () => onFormat('> ', ''),
          ),
          _ToolbarButton(
            icon: Icons.code,
            tooltip: 'Inline code',
            onTap: () => onFormat('`', '`'),
          ),
          _ToolbarButton(
            icon: Icons.integration_instructions,
            tooltip: 'Code block',
            onTap: () => onFormat('```\n', '\n```'),
          ),
          _ToolbarButton(
            icon: Icons.link,
            tooltip: 'Link',
            onTap: () => onFormat('[', '](url)'),
          ),
          _ToolbarButton(
            icon: Icons.image,
            tooltip: 'Image',
            onTap: () => onFormat('![alt](', ')'),
          ),
          _ToolbarButton(
            icon: Icons.horizontal_rule,
            tooltip: 'Horizontal rule',
            onTap: () => onFormat('\n---\n', ''),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
