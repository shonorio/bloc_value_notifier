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

    testWidgets(
      'rebuilds only when buildWhen is true',
      (tester) async {
        final notifier = ValueNotifier<int>(0);

        await tester.pumpWidget(
          ValueNotifierConsumer<int>(
            valueListenable: notifier,
            buildWhen: (value) => value > 0,
            builder: (context, value, child) {
              return Text(
                '$value',
                textDirection: TextDirection.ltr,
              );
            },
          ),
        );

        notifier.value = 0;
        await tester.pump();

        expect(find.text('0'), findsOneWidget);

        notifier.value = 1;
        await tester.pump();

        expect(find.text('1'), findsOneWidget);
      },
    );

    testWidgets(
      'calls listener when listenWhen is true',
      (tester) async {
        final notifier = ValueNotifier<int>(0);
        bool didCallListener = false;

        await tester.pumpWidget(
          ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return Text(
                '$value',
                textDirection: TextDirection.ltr,
              );
            },
            listener: (context, value) => didCallListener = true,
            listenWhen: (value) => value > 0,
          ),
        );

        notifier.value = 1;
        await tester.pump();

        expect(didCallListener, true);
      },
    );

    test(
      'must assert if listener is null but listenWhen is provided',
      () {
        final notifier = ValueNotifier<int>(0);

        expect(
          () => ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) => Container(),
            listenWhen: (value) => value > 0,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'must not assert if both listener and listenWhen are provided',
      () {
        final notifier = ValueNotifier<int>(0);

        expect(
          () => ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) => Container(),
            listener: (context, value) {},
            listenWhen: (value) => value > 0,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'must not assert if both listener and listenWhen are null',
      () {
        final notifier = ValueNotifier<int>(0);

        expect(
          () => ValueNotifierConsumer<int>(
            valueListenable: notifier,
            builder: (context, value, child) => Container(),
          ),
          returnsNormally,
        );
      },
    );
  });
}
