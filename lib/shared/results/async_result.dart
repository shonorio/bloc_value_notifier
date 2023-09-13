import '../app/app_failure.dart';
import 'result.dart';

typedef AsyncResult<S extends Object> = Future<Result<S, AppFailure>>;

extension AsyncResultExtension<S extends Object> on AsyncResult<S> {}
