// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RequestStore on _RequestStore, Store {
  late final _$requestIdAtom =
      Atom(name: '_RequestStore.requestId', context: context);

  @override
  String get requestId {
    _$requestIdAtom.reportRead();
    return super.requestId;
  }

  @override
  set requestId(String value) {
    _$requestIdAtom.reportWrite(value, super.requestId, () {
      super.requestId = value;
    });
  }

  late final _$fetchRequestDetailsAsyncAction =
      AsyncAction('_RequestStore.fetchRequestDetails', context: context);

  @override
  Future<String> fetchRequestDetails() {
    return _$fetchRequestDetailsAsyncAction
        .run(() => super.fetchRequestDetails());
  }

  late final _$_RequestStoreActionController =
      ActionController(name: '_RequestStore', context: context);

  @override
  void setRequestId(String id) {
    final _$actionInfo = _$_RequestStoreActionController.startAction(
        name: '_RequestStore.setRequestId');
    try {
      return super.setRequestId(id);
    } finally {
      _$_RequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requestId: ${requestId}
    ''';
  }
}
