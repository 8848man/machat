import 'dart:io';
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile> resizeIfNeeded(XFile file) async {
  if (kIsWeb) {
    return await resizeImageWeb(file);
  } else {
    return await resizeMobile(file);
  }
}

bool isValidImageExtension(String path) {
  final extension = path.split('.').last.toLowerCase();
  return ['jpg', 'jpeg', 'png'].contains(extension);
}

Future<XFile> resizeMobile(XFile xfile,
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

Future<XFile> resizeImageWeb(XFile xfile,
    {int maxWidth = 1920, int maxHeight = 1080, int quality = 85}) async {
  // XFile → Uint8List
  final bytes = await xfile.readAsBytes();

  // FileReader로 DataUrl 생성
  final reader = html.FileReader();
  final htmlFile = html.File([bytes], xfile.name);
  reader.readAsDataUrl(htmlFile);
  await reader.onLoad.first;

  // ImageElement 생성
  final image = html.ImageElement();
  image.src = reader.result as String;
  await image.onLoad.first;

  // Canvas로 리사이즈
  final canvas = html.CanvasElement();
  final scale = min(maxWidth / image.width!, maxHeight / image.height!);
  final w = (image.width! * scale).toInt();
  final h = (image.height! * scale).toInt();
  canvas.width = w;
  canvas.height = h;

  final ctx = canvas.context2D;
  ctx.drawImageScaled(image, 0, 0, w, h);

  // Canvas → Blob → Uint8List
  final blob = await canvas.toBlob('image/jpeg', quality / 100);
  final reader2 = html.FileReader();
  reader2.readAsArrayBuffer(blob);
  await reader2.onLoad.first;
  final result = reader2.result;
  late Uint8List resizedBytes;

  if (result is ByteBuffer) {
    resizedBytes = Uint8List.view(result);
  } else if (result is Uint8List) {
    resizedBytes = result;
  } else {
    throw Exception('Unexpected result type: ${result.runtimeType}');
  }
  // XFile로 래핑
  return XFile.fromData(resizedBytes, name: xfile.name);
}
