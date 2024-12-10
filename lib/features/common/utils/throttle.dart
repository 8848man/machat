import 'dart:async';
import 'dart:ui';

class ThrottleManager {
  // 마지막 호출을 방지하는 Timer
  Timer? _debounceTimer;

  // Throttle이 적용될 시간 간격 (ms)
  final Duration throttleDuration;

  ThrottleManager({this.throttleDuration = const Duration(milliseconds: 500)});

  // Throttle을 적용하는 함수: 특정 작업을 지정된 시간 간격 내에 여러 번 호출되면 마지막 호출만 실행
  void applyThrottle(VoidCallback action) {
    // 기존 타이머가 활성화되어 있으면 취소
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // 새로운 타이머 설정
    _debounceTimer = Timer(throttleDuration, () {
      action(); // 지정된 작업 실행
    });
  }

  // Timer가 남아 있는지 확인 (필요한 경우)
  bool get isThrottleActive => _debounceTimer?.isActive ?? false;

  // 타이머 취소
  void cancel() {
    _debounceTimer?.cancel();
  }
}
