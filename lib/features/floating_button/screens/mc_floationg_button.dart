part of '../lib.dart';

class AnimatedFAB extends ConsumerStatefulWidget {
  const AnimatedFAB({super.key});

  @override
  _AnimatedFABState createState() => _AnimatedFABState();
}

class _AnimatedFABState extends ConsumerState<AnimatedFAB> {
  bool _isExpanded = false;

  void _toggleButtons() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Small Buttons
        if (_isExpanded)
          Positioned(
            bottom: 80.0, // Main FAB 기준 위치 조정
            right: 16.0,
            child: _buildSmallButtons(),
          ),
        // Main FAB
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _toggleButtons,
            child: Icon(_isExpanded ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButtons() {
    if (kIsWeb) {
      // Web: Row로 좌측으로 버튼 생성
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(1, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SmallButton(
              index: index,
              isWeb: false,
            ),
          );
        }),
      );
    } else {
      // Mobile: Column으로 위로 버튼 생성
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(1, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SmallButton(
              index: index,
              isWeb: false,
            ),
          );
        }),
      );
    }
  }
}

class SmallButton extends ConsumerWidget {
  final int index;
  final bool isWeb;

  const SmallButton({required this.index, required this.isWeb, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(floatingButtonViewModelProvider.notifier);
    return FloatingActionButton(
      mini: true,
      onPressed: () => notifier.functionBrancher(index),
      backgroundColor:
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: Icon(Icons.star),
    );
  }
}
