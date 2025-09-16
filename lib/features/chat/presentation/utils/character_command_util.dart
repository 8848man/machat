import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/data/models/chat_command.dart';
import 'package:machat/features/chat/data/repository/chat_repository.dart';
import 'package:machat/features/chat/presentation/view_models/chat_contents_view_model.dart';
import 'package:machat/features/common/models/ai/ai_chat_request.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';

String getCharacterPrompt(ChatCommand characterCommandModel) =>
    characterCommandModel.data?['prompt']?.toString() ?? '친구같은 AI 어시스턴트';

String getCharacterName(ChatCommand characterCommandModel) =>
    characterCommandModel.text.replaceFirst('/character:', '').trim();

Future<List<AiChatMessage>> buildChatMessages(
    String sendingMessage, Ref ref) async {
  final chatStates = await ref.read(chatContentsViewModelProvider.future);
  final chatContents = chatStates.contents;

  final List<AiChatMessage> messages = chatContents
      .where((e) => (e as Map<String, dynamic>)['type'] == 'chat')
      .map((e) {
    final map = e as Map<String, dynamic>;
    return AiChatMessage(
      user: map['createdBy'] ?? '',
      message: map['message'] ?? '',
      sendDt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }).toList();

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) throw Exception('User is not logged in');

  messages.add(AiChatMessage(
    user: currentUser.uid,
    message: sendingMessage,
    sendDt: DateTime.now(),
  ));

  return messages;
}

Future<void> sendToServer(String userId, String message, Ref ref) async {
  final roomId = ref.read(chatRoomIdProvider);
  final repository = ref.read(chatRepositoryProvider);

  await repository.create({
    'roomId': roomId,
    'message': message,
    'userId': userId,
  });
}
