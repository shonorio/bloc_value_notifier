import 'package:flutter/foundation.dart' show immutable;

import 'result.dart';

@immutable
class Failure<S extends Object, F extends Object> implements Result<S, F> {
  const Failure(this._failure);

  final F _failure;

  @override
  bool isError() => true;

  @override
  bool isSuccess() => false;
}
