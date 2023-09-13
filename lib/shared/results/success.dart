import 'package:flutter/foundation.dart' show immutable;

import 'result.dart';

@immutable
class Success<S extends Object, F extends Object> implements Result<S, F> {
  const Success(this._success);

  final S _success;

  @override
  bool isError() => false;

  @override
  bool isSuccess() => true;
}
