part of '../lib.dart';

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

void showSnackBar(
  dynamic ref,
  String text,
) {
  SnackBarCaller().callSnackBar(ref, text);
}
