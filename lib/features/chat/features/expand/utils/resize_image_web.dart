// resize_image_web.dart
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

Future<XFile> resizeImpl(XFile xfile,
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
