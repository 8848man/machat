import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_request.freezed.dart';
part 'ai_chat_request.g.dart';

/// 전체 요청 모델
@freezed
class AiChatRequest with _$AiChatRequest {
  const factory AiChatRequest({
    required String character_prompt,
    required List<AiChatMessage> messages,
  }) = _AiChatRequest;

  factory AiChatRequest.fromJson(Map<String, dynamic> json) =>
      _$AiChatRequestFromJson(json);
}

/// 개별 메시지 모델
@freezed
class AiChatMessage with _$AiChatMessage {
  const factory AiChatMessage({
    required String user,
    required String message,
    required DateTime sendDt,
  }) = _AiChatMessage;

  factory AiChatMessage.fromJson(Map<String, dynamic> json) =>
      _$AiChatMessageFromJson(json);
}

// helper
DateTime _dateTimeFromString(String date) => DateTime.parse(date);
