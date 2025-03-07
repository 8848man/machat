import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_image_list.freezed.dart';

@freezed
class XFileList with _$XFileList {
  const factory XFileList({
    required List<XFile?> images,
  }) = _XFileList;
}
