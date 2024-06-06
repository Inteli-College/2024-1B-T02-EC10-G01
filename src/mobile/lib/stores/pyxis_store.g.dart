// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pyxis_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PyxisStore on _PyxisStore, Store {
  late final _$currentPyxisDataAtom =
      Atom(name: '_PyxisStore.currentPyxisData', context: context);

  @override
  ObservableMap<dynamic, dynamic> get currentPyxisData {
    _$currentPyxisDataAtom.reportRead();
    return super.currentPyxisData;
  }

  @override
  set currentPyxisData(ObservableMap<dynamic, dynamic> value) {
    _$currentPyxisDataAtom.reportWrite(value, super.currentPyxisData, () {
      super.currentPyxisData = value;
    });
  }

  late final _$_PyxisStoreActionController =
      ActionController(name: '_PyxisStore', context: context);

  @override
  void setCurrentPyxisData(Map<dynamic, dynamic> data) {
    final _$actionInfo = _$_PyxisStoreActionController.startAction(
        name: '_PyxisStore.setCurrentPyxisData');
    try {
      return super.setCurrentPyxisData(data);
    } finally {
      _$_PyxisStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPyxisData: ${currentPyxisData}
    ''';
  }
}
