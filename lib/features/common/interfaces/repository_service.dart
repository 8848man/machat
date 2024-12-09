abstract class RepositoryService {
  Future<Map<String, dynamic>> create(Map<String, dynamic> data);
  Future<Map<String, dynamic>> read(String id);
  Future<List<Map<String, dynamic>>> readAll({String? searchId});
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data);
  Future<void> delete(String id);
}
