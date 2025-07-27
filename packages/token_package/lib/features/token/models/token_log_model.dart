import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'token_log_model.freezed.dart';
part 'token_log_model.g.dart';

/// 토큰 로그 타입 열거형
enum TokenLogType {
  dailyReward,    // 일일 보상
  purchase,       // 구매
  usage,          // 사용
  refund,         // 환불
  bonus,          // 보너스
  admin,          // 관리자 지급
}

@freezed
class TokenLogModel with _$TokenLogModel {
  const factory TokenLogModel({
    required String id,
    required String userId,
    required TokenLogType type,
    required int amount,
    required int balanceBefore,
    required int balanceAfter,
    String? description,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
  }) = _TokenLogModel;

  factory TokenLogModel.fromJson(Map<String, dynamic> json) => _$TokenLogModelFromJson(json);

  /// Firestore에서 데이터를 가져와 TokenLogModel로 변환
  factory TokenLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TokenLogModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: TokenLogType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TokenLogType.usage,
      ),
      amount: data['amount'] ?? 0,
      balanceBefore: data['balanceBefore'] ?? 0,
      balanceAfter: data['balanceAfter'] ?? 0,
      description: data['description'],
      metadata: data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

extension TokenLogModelExtension on TokenLogModel {
  /// Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'description': description,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// 로그 타입에 따른 설명 생성
  String get displayDescription {
    switch (type) {
      case TokenLogType.dailyReward:
        return '일일 보상';
      case TokenLogType.purchase:
        return '토큰 구매';
      case TokenLogType.usage:
        return '토큰 사용';
      case TokenLogType.refund:
        return '환불';
      case TokenLogType.bonus:
        return '보너스';
      case TokenLogType.admin:
        return '관리자 지급';
    }
  }

  /// 금액 표시 (양수/음수)
  String get displayAmount {
    final prefix = amount >= 0 ? '+' : '';
    return '$prefix$amount';
  }
} 