import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatImage extends ConsumerWidget {
  const ChatImage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Image.network(
        url,
        fit: BoxFit.cover, // 이미지 크기 조정
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
        },
        errorBuilder: (context, error, stackTrace) {
          print('test001, error occured error is $error');
          return Icon(Icons.error); // 이미지 로딩 실패 시 기본 아이콘 표시
        },
      ),
    );
  }
}
