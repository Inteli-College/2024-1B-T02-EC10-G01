// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pyxis_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PyxisStore on _PyxisStore, Store {
  late final _$currentPyxisIdAtom =
      Atom(name: '_PyxisStore.currentPyxisId', context: context);

  @override
  int get currentPyxisId {
    _$currentPyxisIdAtom.reportRead();
    return super.currentPyxisId;
  }

  @override
  set currentPyxisId(int value) {
    _$currentPyxisIdAtom.reportWrite(value, super.currentPyxisId, () {
      super.currentPyxisId = value;
    });
  }

  late final _$_PyxisStoreActionController =
      ActionController(name: '_PyxisStore', context: context);

  @override
  void setCurrentPyxisId(dynamic id) {
    final _$actionInfo = _$_PyxisStoreActionController.startAction(
        name: '_PyxisStore.setCurrentPyxisId');
    try {
      return super.setCurrentPyxisId(id);
    } finally {
      _$_PyxisStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPyxisId: ${currentPyxisId}
    ''';
  }
}
