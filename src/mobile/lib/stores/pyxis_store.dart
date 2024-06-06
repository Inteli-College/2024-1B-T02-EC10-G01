import 'package:mobx/mobx.dart';

part 'pyxis_store.g.dart';

class PyxisStore = _PyxisStore with _$PyxisStore;

abstract class _PyxisStore with Store {
  @observable
  var currentPyxisId = -1;

  @action
  void setCurrentPyxisId(dynamic id) {
    currentPyxisId = id;
  }
}
