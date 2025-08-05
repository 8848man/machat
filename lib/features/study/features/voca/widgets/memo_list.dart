import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

// class VocaMemoList extends ConsumerWidget {
//   const VocaMemoList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return const Center(child: MemoCard());
//   }
// }

// class MemoCard extends StatelessWidget {
//   const MemoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 130,
//       width: 250,
//       child: Card(
//         elevation: 10, // 높을수록 그림자가 진하고 넓게 퍼짐
//         shadowColor: Colors.black.withOpacity(1), // 그림자 색상 및 투명도
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12), // 모서리 둥글게
//         ),
//         color: MCColors.$color_blue_10,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "English",
//                 style: TextStyle(color: MCColors.$color_grey_10, fontSize: 18),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Serendipity",
//                 style: TextStyle(color: MCColors.$color_grey_100, fontSize: 24),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class VocaMemoList extends StatefulWidget {
  const VocaMemoList({super.key});

  @override
  State<VocaMemoList> createState() => _VocaMemoListState();
}

class _VocaMemoListState extends State<VocaMemoList> {
  final ScrollController _scrollController = ScrollController();
  double _itemExtent = 150;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 매 스크롤마다 상태 갱신 → 화면에 애니메이션 적용 가능
    setState(() {});
  }

  void _snapToNearestItem() {
    final offset = _scrollController.offset;
    final index = (offset / _itemExtent).round();
    final targetOffset = index * _itemExtent;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxCardWidth = 500.0;
    const double minScale = 0.85;
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        _snapToNearestItem(); // 스크롤이 멈췄을 때만 실행됨
        return true;
      },
      child: ListView.builder(
        controller: _scrollController,
        // physics: const BouncingScrollPhysics(), // 또는 BouncingScrollPhysics()
        itemExtent: _itemExtent,
        itemCount: 20,
        itemBuilder: (context, index) {
          final scrollOffset = _scrollController.offset;
          final screenHeight = MediaQuery.of(context).size.height;
          final viewportCenter = scrollOffset + screenHeight * 0.4;

          final itemCenterOffset = index * _itemExtent + _itemExtent / 2;
          final distance = (itemCenterOffset - viewportCenter).abs();

          double scale = 1.0 - (distance / screenHeight);
          scale = scale.clamp(minScale, 1.0);

          // 실제 카드 너비를 scale에 따라 조정
          final cardWidth = maxCardWidth * scale;

          return Center(
            child: SizedBox(
              width: cardWidth,
              height: 150,
              child: Transform.scale(
                scale: scale, // 시각적으로 더 부드럽게
                alignment: Alignment.center,
                child: MemoCard(index: index),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MemoCard extends StatelessWidget {
  final int index;

  const MemoCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: MCColors.$color_blue_10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("English",
                  style:
                      TextStyle(color: MCColors.$color_grey_10, fontSize: 18)),
              const SizedBox(height: 8),
              Text("Serendipity #$index",
                  style:
                      TextStyle(color: MCColors.$color_grey_100, fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
