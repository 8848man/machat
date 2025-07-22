part of '../../../lib.dart';

class ChatExpand extends ConsumerStatefulWidget {
  const ChatExpand({super.key});

  @override
  ConsumerState<ChatExpand> createState() => _ChatExpandState();
}

class _ChatExpandState extends ConsumerState<ChatExpand>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // 아래에서 시작
      end: const Offset(0, 0), // 원래 위치
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addObserver(this); // ✅ 키보드 상태 감지 등록
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ 키보드 감지 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      _controller.reverse(); // ✅ 키보드 올라오면 애니메이션 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExpandWidgetState expandState = ref.watch(expandWidgetStateProvider);

    if (expandState != ExpandWidgetState.collapsed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: buildExpand(expandState),
    );
  }

  // expand 토큰에 따른 확장 위젯 표현
  Widget buildExpand(ExpandWidgetState expandState) {
    return expandState != ExpandWidgetState.collapsed
        ? Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: 340,
                width: double.infinity,
                color: MCColors.$color_grey_00,
                child: const ChatExpandBrancher(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
