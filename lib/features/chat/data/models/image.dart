import 'package:freezed_annotation/freezed_annotation.dart';

part 'image.freezed.dart';
part 'image.g.dart';

@freezed
class McImage with _$McImage {
  const factory McImage({
    required String imageUrl,
    required String createdBy,
    required String createdAt,
    @Default(false) bool isMine,
  }) = _McImage;

  factory McImage.fromJson(Map<String, dynamic> json) =>
      _$McImageFromJson(json);
}
