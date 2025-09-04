// import 'package:machat/features/chat/repository/chat_contents_repository.dart';

// class ChatContentsService {
//   final ChatContentsRepository repository;

//   ChatContentsService(this.repository);

//   Future<List<ChatMessageModel>> getInitialChats(String roomId) async {
//     // 1. 캐시 먼저
//     final cached = await repository.getChatsFromCache(roomId);
//     if (cached.isNotEmpty) return cached;

//     // 2. 없으면 Firestore
//     final remote = await repository.getChatsFromFirestore(roomId);
//     return remote;
//   }
// }
