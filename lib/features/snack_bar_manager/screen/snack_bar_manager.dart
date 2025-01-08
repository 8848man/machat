part of '../lib.dart';

// 스낵바를 표현하기 위한 위젯.
// 스낵바를 표현하는 위젯에 Stack해서 사용하면 됨.
// Stack 쓰는 이유는 스낵바 매니저가 새로고침할 때
// 하위 위젯은 새로고침되지 않게 하기 위해서입니다.
class SnackBarManager extends ConsumerWidget {
  const SnackBarManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 스낵바 상태를 구독
    final SnackBarManagerData snackBarState =
        ref.watch(snackBarManagerProvider);

    // 스낵바를 호출하는 함수
    void handleSnackBarCall() {
      print(
          'snackBarState.dialogCall: ${snackBarState.dialogCall}, snackBarState.text: ${snackBarState.text}');
      if (snackBarState.dialogCall) {
        print(
            'test001, dialogCall is ${snackBarState.dialogCall} , snackBarState.text: ${snackBarState.text}');
        final snackBarNotifier = ref.read(snackBarManagerProvider.notifier);

        // 실제 스낵바를 띄우는 함수 호출
        toastification.show(
          context: context,
          title: Text(snackBarNotifier.state.text),
          autoCloseDuration: const Duration(seconds: 2),
        );

        // 스낵바 리셋 함수 호출
        SnackBarCaller().resetSnackBar(ref);
      }
    }

    // 프레임이 완료된 후 스낵바 호출 처리
    WidgetsBinding.instance.addPostFrameCallback((_) => handleSnackBarCall());

    return Container();
  }
}

// 컨텐츠 위젯을 child로 받도록 설계된 커넥터
class SnackBarManagerConnector extends StatelessWidget {
  final Widget child;
  const SnackBarManagerConnector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SnackBarManager(),
        child,
      ],
    );
  }
}
