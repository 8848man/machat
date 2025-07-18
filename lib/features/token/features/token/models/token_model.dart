import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    required String userId,
    @Default(0) int currentTokens,
    @Default(0) int totalEarnedTokens,
    @Default(0) int totalSpentTokens,
    required DateTime lastDailyReward,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  factory TokenModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TokenModel(
      userId: doc.id,
      currentTokens: data['currentTokens'] ?? 0,
      totalEarnedTokens: data['totalEarnedTokens'] ?? 0,
      totalSpentTokens: data['totalSpentTokens'] ?? 0,
      lastDailyReward: (data['lastDailyReward'] as Timestamp?)?.toDate() ??
          DateTime.now().subtract(const Duration(days: 2)),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

extension TokenModelExtension on TokenModel {
  Map<String, dynamic> toFirestore() {
    return {
      'currentTokens': currentTokens,
      'totalEarnedTokens': totalEarnedTokens,
      'totalSpentTokens': totalSpentTokens,
      'lastDailyReward': Timestamp.fromDate(lastDailyReward),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool canReceiveDailyReward() {
    final now = DateTime.now();
    final lastReward = lastDailyReward;

    return now.year != lastReward.year ||
        now.month != lastReward.month ||
        now.day != lastReward.day;
  }
}
