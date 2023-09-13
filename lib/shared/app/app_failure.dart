import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppFailure {}

@immutable
class ServerFailure implements AppFailure {
  const ServerFailure();
}
