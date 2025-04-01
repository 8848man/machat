import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat_expand_image/providers/selected_image_url_provider.dart';

class ExpandImage extends ConsumerWidget {
  const ExpandImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String url = ref.read(selectedImageUrlProvider);
    return Container(
      color: MCColors.$color_grey_20,
      child: Stack(
        fit: StackFit.expand,
        children: [
          buildImage(url),
          buildOverlay(),
        ],
      ),
    );
  }

  Widget buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.scaleDown, // 이미지 크기 조정
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error); // 이미지 로딩 실패 시 기본 아이콘 표시
      },
    );
  }

  Widget buildOverlay() {
    return Column(
      children: [
        Container(
          height: 100,
          color: Colors.black.withOpacity(0.4),
          child: buildOverlayHeader(),
        ),
        const Spacer(),
        Container(
          height: 100,
          color: Colors.black.withOpacity(0.4),
          // child: buildOverlayFooter(),
        ),
      ],
    );
  }

  Widget buildOverlayHeader() {
    return Row(
      children: [
        buildForeHeader(),
        const Spacer(),
        buildTailHeader(),
      ],
    );
  }

  Widget buildOverlayFooter() {
    return Row(
      children: [
        buildForeFooter(),
        const Spacer(),
        buildTailFooter(),
      ],
    );
  }

  Widget buildForeHeader() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          color: Colors.white,
          child: const BackButton(),
        ),
        const SizedBox(width: 10),
        // Container(
        //   width: 70,
        //   height: 70,
        //   color: Colors.white,
        // ),
      ],
    );
  }

  Widget buildTailHeader() {
    return Row(
      children: [
        // Container(
        //   width: 70,
        //   height: 70,
        //   color: Colors.white,
        // ),
        // const SizedBox(width: 10),
        // Container(
        //   width: 70,
        //   height: 70,
        //   color: Colors.white,
        // ),
      ],
    );
  }

  Widget buildForeFooter() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Container(
          width: 70,
          height: 70,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget buildTailFooter() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Container(
          width: 70,
          height: 70,
          color: Colors.white,
        ),
      ],
    );
  }
}
