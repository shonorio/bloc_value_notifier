import 'package:flutter/foundation.dart' show immutable;

import 'failure.dart';
import 'success.dart';

@immutable
abstract class Result<S extends Object, F extends Object> {
  factory Result.success(S s) => Success(s);
  factory Result.failure(F e) => Failure(e);

  bool isError();

  bool isSuccess();
}
