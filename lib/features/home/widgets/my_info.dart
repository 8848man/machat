part of '../lib.dart';

class MyInfo extends ConsumerWidget {
  const MyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserData> userState = ref.watch(userViewModelProvider);
    final FriendsViewModel notifier =
        ref.read(friendsViewModelProvider.notifier);
    return userState.when(
      data: (data) {
        return buildMyInfo(
          user: data,
          notifier: notifier,
        );
      },
      error: (error, stackTrace) {
        showSnackBar(ref, '사용자 정보를 가져오는데 실패했습니다.');
        return const Text('사용자 정보를 가져오는데 실패했습니다.');
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildMyInfo({
    required UserData user,
    required FriendsViewModel notifier,
  }) {
    return infoBox(
      child: Row(
        children: [
          gradientAvatar(
            user: user,
            notifier: notifier,
          ),
          const SizedBox(width: 10),
          profileTextColumn(user),
        ],
      ),
    );
  }
}
