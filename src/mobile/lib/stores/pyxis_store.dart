import 'package:mobx/mobx.dart';

part 'pyxis_store.g.dart';

class PyxisStore = _PyxisStore with _$PyxisStore;

abstract class _PyxisStore with Store {
  @observable
  ObservableMap<dynamic, dynamic> currentPyxisData = ObservableMap<dynamic, dynamic>();

  @action
  void setCurrentPyxisData(Map<dynamic, dynamic> data) {
    currentPyxisData.clear();
    currentPyxisData.addAll(data);
  }
}
