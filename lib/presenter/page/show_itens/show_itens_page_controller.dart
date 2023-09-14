import 'package:flutter/foundation.dart' show ValueNotifier;

import '../../../domain/repositories/get_list_repository.dart';
import '../../bloc/app_state.dart';

class ShowItensPageController extends ValueNotifier<AppState> {
  final GetListRepository _repository;

  ShowItensPageController({required GetListRepository repository})
      : _repository = repository,
        super(AppState.initial());

  Future<void> load() async {
    value = AppState.loading();

    final result = await _repository();
    value = result.fold(
      (success) => AppState.success(success),
      (failure) => AppState.failure(
          'An unexpected error occurred while generating accessing the server. Please try again later.'),
    );
  }
}
