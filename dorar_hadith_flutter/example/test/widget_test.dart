import 'package:dorar_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'initialization failure remains visible without performing lookups',
    (tester) async {
      await tester.pumpWidget(
        const DorarExample(initializationError: 'missing asset'),
      );
      expect(find.text('Initialization failed: missing asset'), findsOneWidget);
    },
  );
}
