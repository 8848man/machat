part of '../lib.dart';

class MyInfo extends ConsumerWidget {
  const MyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserData> userState = ref.watch(userViewModelProvider);
    return userState.when(
      data: (data) {
        return McAppear(
          child: buildInfo(
            user: data,
            ref: ref,
            context: context,
          ),
        );
      },
      error: (error, stackTrace) {
        showSnackBar(ref, '사용자 정보를 가져오는데 실패했습니다.');
        return const Text('사용자 정보를 가져오는데 실패했습니다.');
      },
      loading: () {
        return Container();
      },
    );
  }
}
