import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/ai/ai_chat_request.dart';
import 'package:machat/features/common/models/ai/ai_chat_response.dart';
import 'package:machat/features/ai/repositories/ai_repository.dart';

final aiFacadeProvider = Provider<AiFacade>((ref) {
  final repository = ref.read(aiRepositoryProvider);
  return AiFacade(repository: repository, ref: ref);
});

class AiFacade {
  final AiRepository repository;
  final Ref ref;

  AiFacade({required this.repository, required this.ref});

  /// AI 채팅 응답 생성
  Future<AiChatResponseModel?> createChatResponse(AiChatRequest request) async {
    try {
      final response = await repository.getChatResponse(request);
      return response;
    } catch (e, st) {
      print('AiFacade.createChatResponse error: $e\n$st');
      return null;
    } finally {}
  }
}
