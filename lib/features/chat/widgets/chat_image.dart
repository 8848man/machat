import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/expand_image/providers/selected_image_url_provider.dart';
import 'package:machat/router/lib.dart';

class ChatImage extends ConsumerWidget {
  const ChatImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: SizedBox(
        child: Image.network(
          url,
          fit: BoxFit.cover, // 이미지 크기 조정
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
                child: CircularProgressIndicator()); // 로딩 인디케이터 표시
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error); // 이미지 로딩 실패 시 기본 아이콘 표시
          },
        ),
      ),
      onTap: () {
        // 선택된 이미지 변경
        ref.read(selectedImageUrlProvider.notifier).state = url;
        ref.read(goRouterProvider).goNamed(RouterPath.chatImage.name);
      },
    );
  }
}
