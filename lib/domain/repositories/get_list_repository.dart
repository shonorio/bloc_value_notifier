import 'dart:math';

import 'package:flutter/foundation.dart' show immutable;

import '../../shared/app/app_failure.dart';
import '../../shared/results/async_result.dart';
import '../../shared/results/failure.dart';
import '../../shared/results/success.dart';
import '../entities/item_entity.dart';

@immutable
class GetListRepository {
  AsyncResult<Iterable<ItemEntity>> call() async {
    return Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (Random().nextBool()) {
          return Success(_generateItens());
        } else {
          return const Failure(ServerFailure());
        }
      },
    );
  }

  Iterable<ItemEntity> _generateItens() =>
      Iterable.generate(10, (i) => ItemEntity('Item ${i + 1}'));
}
