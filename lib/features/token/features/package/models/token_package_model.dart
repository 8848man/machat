import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/token/features/commons/utils/parse_date.dart';

part 'token_package_model.freezed.dart';
part 'token_package_model.g.dart';

@freezed
class TokenPackageModel with _$TokenPackageModel {
  const factory TokenPackageModel({
    required String id,
    required String name,
    required String description,
    required int tokenAmount,
    required double price,
    @Default('KRW') String currency,
    @Default(true) bool isActive,
    @Default(false) bool isPopular,
    int? bonusTokens,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TokenPackageModel;

  factory TokenPackageModel.fromJson(Map<String, dynamic> json) =>
      _$TokenPackageModelFromJson(json);

  factory TokenPackageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TokenPackageModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      tokenAmount: data['tokenAmount'] ?? 0,
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'KRW',
      isActive: data['isActive'] ?? true,
      isPopular: data['isPopular'] ?? false,
      bonusTokens: data['bonusTokens'],
      imageUrl: data['imageUrl'],
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
      // createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
    );
  }
}

extension TokenPackageModelExtension on TokenPackageModel {
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'tokenAmount': tokenAmount,
      'price': price,
      'currency': currency,
      'isActive': isActive,
      'isPopular': isPopular,
      'bonusTokens': bonusTokens,
      'imageUrl': imageUrl,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  int get totalTokens => tokenAmount + (bonusTokens ?? 0);

  String get displayPrice {
    switch (currency) {
      case 'KRW':
        return '₩${price.toStringAsFixed(0)}';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      default:
        return '${price.toStringAsFixed(2)} $currency';
    }
  }

  double get pricePerToken {
    if (totalTokens == 0) return 0;
    return price / totalTokens;
  }

  String? get bonusDisplay {
    if (bonusTokens == null || bonusTokens == 0) return null;
    return '+$bonusTokens 보너스';
  }
}
