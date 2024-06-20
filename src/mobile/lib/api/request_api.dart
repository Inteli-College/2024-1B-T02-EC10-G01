abstract class RequestApi {
  Future<dynamic> getRequestById(int id);
  Future<List<dynamic>> getHistory();
  Future<Map> getPyxisByPyxisId(int pyxisId);
  Future<dynamic> sendRequest(int pyxisId, int itemId);
  Future<dynamic> getLastRequest();
  Future<dynamic> updateRequestStatus(int requestId);
}
