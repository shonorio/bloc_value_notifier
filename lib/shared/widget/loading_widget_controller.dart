import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingWidgetController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingWidgetController({
    required this.close,
    required this.update,
  });
}
