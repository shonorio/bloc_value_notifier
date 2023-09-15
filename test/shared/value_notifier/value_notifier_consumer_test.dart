import 'package:bloc_value_notifier/shared/value_notifier/value_notifier_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ValueNotifierConsumer<int>, () {
    testWidgets(
      'renders ValueNotifier value',
      (tester) async {
        final notifier = ValueNotifier<int>(0);

        await tester.pumpWidget(
          ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return Text(
                '$value',
                textDirection: TextDirection.ltr,
              );
            },
          ),
        );

        expect(find.text('0'), findsOneWidget);
      },
    );

    testWidgets(
      'rebuilds when value changes',
      (tester) async {
        final notifier = ValueNotifier<int>(0);

        await tester.pumpWidget(
          ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return Text(
                '$value',
                textDirection: TextDirection.ltr,
              );
            },
          ),
        );

        notifier.value = 1;
        await tester.pump();

        expect(find.text('1'), findsOneWidget);
      },
    );
  });
}
