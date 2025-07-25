part of '../lib.dart';

class AnimatedFAB extends ConsumerStatefulWidget {
  const AnimatedFAB({super.key});

  @override
  _AnimatedFABState createState() => _AnimatedFABState();
}

class _AnimatedFABState extends ConsumerState<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _rotationController;

  @override
  initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleButtons() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded
          ? _rotationController.forward()
          : _rotationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Small Buttons
        // if (_isExpanded)
        Positioned(
          bottom: 80.0, // Main FAB 기준 위치 조정
          right: 16.0,
          child: _buildSmallButtons(),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _toggleButtons,
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: 0.125)
                  .animate(_rotationController),
              child: const Icon(Icons.add),
            ),
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
        children: List.generate(3, (index) {
          final appearDelay = index * 50;
          final disappearDelay = (3 - 1 - index) * 50;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: McAppear(
              delayMs:
                  _isExpanded ? appearDelay : disappearDelay, // 각 버튼마다 딜레이 적용
              isAppear: _isExpanded,
              child: SmallButton(
                index: index,
              ),
            ),
          );
        }),
      );
    } else {
      // Mobile: Column으로 위로 버튼 생성
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final appearDelay = (3 - 1 - index) * 50;
          // final disappearDelay = index * 50;[=]
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: McAppear(
              delayMs:
                  // _isExpanded ? appearDelay : disappearDelay, // 각 버튼마다 딜레이 적용
                  appearDelay,
              isAppear: _isExpanded,
              child: SmallButton(
                index: index,
              ),
            ),
          );
        }),
      );
    }
  }
}

class SmallButton extends ConsumerWidget {
  final int index;
  const SmallButton({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(floatingButtonViewModelProvider.notifier);
    return FloatingActionButton(
      mini: true,
      onPressed: () => notifier.functionBrancher(index),
      backgroundColor: MCColors.$color_blue_40,
      child: SvgPicture.asset(notifier.iconUrl[index]),
    );
  }
}
