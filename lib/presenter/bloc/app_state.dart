import '../../domain/entities/item_entity.dart';

sealed class AppState {
  const AppState();
  factory AppState.initial() = AppStateInitial;
  factory AppState.loading() = AppStateLoading;
  factory AppState.success(Iterable<ItemEntity> elements) = AppStateSuccess;
  factory AppState.failure(String message) = AppStateFailure;

  R map<R>({
    required R Function(AppStateInitial) initial,
    required R Function(AppStateLoading) loading,
    required R Function(AppStateSuccess) success,
    required R Function(AppStateFailure) failure,
  }) {
    if (this is AppStateInitial) {
      return initial.call(this as AppStateInitial);
    }

    if (this is AppStateLoading) {
      return loading.call(this as AppStateLoading);
    }

    if (this is AppStateSuccess) {
      return success.call(this as AppStateSuccess);
    }

    if (this is AppStateFailure) {
      return failure.call(this as AppStateFailure);
    }

    return initial.call(this as AppStateInitial);
  }

  R maybeMap<R>({
    R Function(AppStateInitial)? initial,
    R Function(AppStateLoading)? loading,
    R Function(AppStateSuccess)? success,
    R Function(AppStateFailure)? failure,
    required R Function() orElse,
  }) {
    if (this is AppStateInitial && initial != null) {
      return initial.call(this as AppStateInitial);
    }

    if (this is AppStateLoading && loading != null) {
      return loading.call(this as AppStateLoading);
    }

    if (this is AppStateSuccess && success != null) {
      return success.call(this as AppStateSuccess);
    }

    if (this is AppStateFailure && failure != null) {
      return failure.call(this as AppStateFailure);
    }

    return orElse.call();
  }
}

class AppStateInitial extends AppState {}

class AppStateLoading extends AppState {}

class AppStateSuccess extends AppState {
  final Iterable<ItemEntity> elements;

  AppStateSuccess(this.elements);
}

class AppStateFailure extends AppState {
  final String message;

  AppStateFailure(this.message);
}
