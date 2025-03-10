import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_expand_model.freezed.dart';

@freezed
class ChatExpandModel with _$ChatExpandModel {
  const factory ChatExpandModel({
    required List<XFile?> images,
  }) = _ChatExpandModel;
}
