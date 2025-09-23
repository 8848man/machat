import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile> resizeImpl(XFile xfile,
    {int maxWidth = 1920, int maxHeight = 1080, int quality = 85}) async {
  final result = await FlutterImageCompress.compressWithFile(
    xfile.path,
    minWidth: maxWidth,
    minHeight: maxHeight,
    quality: quality,
  );

  if (result == null) {
    return xfile; // 압축 실패 시 원본 반환
  }

  // 임시 파일로 저장
  final newPath = "${xfile.path}_resized.jpg";
  final newFile = await File(newPath).writeAsBytes(result);
  return XFile(newFile.path);
}
