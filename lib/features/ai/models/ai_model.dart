import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'ai_model.freezed.dart';
part 'ai_model.g.dart';

@freezed
class AiModel with _$AiModel {
  const factory AiModel({
    /// AI 이름 (예: ChatGPT, Gemini, CustomBot)
    required String name,

    /// 간단한 설명 (예: "친절한 학습 도우미")
    String? description,

    /// 성격 태그 (예: ["친절함", "분석적", "유머러스"])
    @Default([]) List<String> traits,

    /// 대화 스타일 (예: "격식체", "친근한 말투", "전문적")
    String? speakingStyle,

    /// 주요 역할 (예: "영어 학습 보조", "코딩 도우미", "정신적 상담")
    String? role,

    /// 프롬프트
    String? prompt,

    /// 생성 일시
    DateTime? createdAt,

    /// 누가 만들었는지
    @Default("") String createdBy,
  }) = _AiModel;

  factory AiModel.fromJson(Map<String, dynamic> json) =>
      _$AiModelFromJson(json);
}

@freezed
class AiModelPage with _$AiModelPage {
  const factory AiModelPage({
    required List<AiModel> models,
    @JsonKey(ignore: true) DocumentSnapshot? lastDoc,
  }) = _AiModelPage;

  factory AiModelPage.fromJson(Map<String, dynamic> json) =>
      _$AiModelPageFromJson(json);
}
