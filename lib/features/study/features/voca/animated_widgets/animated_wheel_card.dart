import 'package:flutter/material.dart';

// builder child를 받아와서 애니메이션 Card ListView를 만들어주는 위젯
class AnimatedWheelCardView extends StatefulWidget {
  final int length;
  final Widget Function(BuildContext, int, bool, bool Function()?) itemBuilder;
  final double itemExtent;
  // 여기에 fetchMore 콜백 추가
  final Future<void> Function()? onFetchMore;

  const AnimatedWheelCardView({
    super.key,
    required this.length,
    required this.itemBuilder,
    this.itemExtent = 150.0,
    this.onFetchMore,
  });

  @override
  State<AnimatedWheelCardView> createState() => _AnimatedWheelCardViewState();
}

class _AnimatedWheelCardViewState extends State<AnimatedWheelCardView> {
  late FixedExtentScrollController _controller;
  int _selectedIndex = 0;

  // 중복 호출 방지용 플래그
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final newIndex = _controller.selectedItem;
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }

    // 위젯 총 길이 - 10일 때 데이터를 더 가져올 수 있도록
    if (!_isFetchingMore &&
        widget.length > 0 &&
        newIndex >= widget.length - 2 &&
        widget.onFetchMore != null) {
      _isFetchingMore = true;

      widget.onFetchMore!().whenComplete(() {
        if (mounted) {
          setState(() {
            _isFetchingMore = false;
          });
        }
      });
    }
  }

  bool _goToIndex(int index) {
    if (index >= 0 && index < widget.length) {
      _controller.animateToItem(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: widget.itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      diameterRatio: 2.5,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.length,
        builder: (context, index) {
          final isFocused = index == _selectedIndex;

          return _AnimatedCardWrapper(
            isFocused: isFocused,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _goToIndex(index),
              child: widget.itemBuilder(
                  context, index, isFocused, () => _goToIndex(index)),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final bool isFocused;

  const _AnimatedCardWrapper({
    required this.child,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: isFocused ? 320 : 260,
        height: 150,
        child: child,
      ),
    );
  }
}
