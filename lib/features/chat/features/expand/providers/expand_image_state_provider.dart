import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/features/expand/models/chat_image_list.dart';

// expand 위젯의 이미지 상태 관리 프로바이더
final expandImageStateProvider =
    StateProvider<XFileList>((ref) => const XFileList(images: []));
