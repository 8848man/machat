import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_response.freezed.dart';
part 'ai_chat_response.g.dart';

@freezed
class AiChatResponseModel with _$AiChatResponseModel {
  const factory AiChatResponseModel({
    required String message,
    required String model_used,
    @JsonKey(fromJson: _scoreFromJson, toJson: _scoreToJson)
    required String confidence_score,
    required DateTime timestamp,
  }) = _AiChatResponseModel;

  factory AiChatResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AiChatResponseModelFromJson(json);
}

String _scoreFromJson(dynamic value) => value.toString();
dynamic _scoreToJson(String value) => value;
