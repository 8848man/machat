part of '../lib.dart';

// 앱에서 사용할 스낵바 호출 함수
// WidgetRef나 Ref가 있는 어디에서든 스낵바 상태를 변경할 수 있습니다.
class SnackBarCaller {
  void callSnackBar(
    dynamic ref,
    String text,
  ) {
    if (ref is Ref) {
      Ref typedRef = ref; // Ref 타입으로 새로운 변수에 할당
      typedRef.read(snackBarManagerProvider.notifier).state =
          SnackBarManagerData(
        text: text,
        dialogCall: true,
      );
    } else if (ref is WidgetRef) {
      WidgetRef typedWidgetRef = ref; // WidgetRef 타입으로 새로운 변수에 할당
      typedWidgetRef.read(snackBarManagerProvider.notifier).state =
          SnackBarManagerData(
        text: text,
        dialogCall: true,
      );
    } else {
      throw ArgumentError(
          '''callSnackBar error! Invalid ref type: ${ref.runtimeType}
          it must be WidgetRef or Ref''');
    }
  }

  void resetSnackBar(
    WidgetRef ref,
  ) {
    ref.read(snackBarManagerProvider.notifier).state = SnackBarManagerData(
      text: 'default value',
      dialogCall: false,
    );
  }
}
