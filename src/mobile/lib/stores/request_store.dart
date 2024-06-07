import 'package:mobx/mobx.dart';

part 'request_store.g.dart';

class RequestStore = _RequestStore with _$RequestStore;

abstract class _RequestStore with Store {
  @observable
  String requestId = '';

  @action
  void setRequestId(String id) {
    requestId = id;
  }

  // Mock function to simulate fetching a request
  @action
  Future<String> fetchRequestDetails() async {
    await Future.delayed(Duration(seconds: 2)); // simulate network delay
    return "Details of request ID: $requestId";
  }
}
