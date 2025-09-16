abstract class IChatContentsRepository {
  Future<List<Map<String, dynamic>>> getInitialChats(String roomId);
  Future<List<Map<String, dynamic>>> getPreviousChats({
    required String roomId,
    required DateTime lastCreatedAt,
  });
  Future<void> deleteChatFromMyself({
    required String roomId,
    required String chatId,
    required String userId,
  });
  Future<void> deleteChatFromAll({
    required String roomId,
    required String chatId,
  });
}
