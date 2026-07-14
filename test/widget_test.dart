import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_markdown_viewer/app.dart';

void main() {
  testWidgets('App renders without error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MarkdownReaderApp()),
    );
    expect(find.text('Markdown Reader'), findsOneWidget);
    expect(find.text('Open File'), findsOneWidget);
  });
}
