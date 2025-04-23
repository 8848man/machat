part of '../lib.dart';

class FriendListWidget extends ConsumerWidget {
  const FriendListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<FriendListModel> state =
        ref.watch(friendListViewModelProvider);

    return state.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.friends.length,
          itemBuilder: (context, index) {
            final UserData friend = data.friends[index];
            return buildInfo(user: friend, ref: ref, context: context);
          },
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('친구 목록을 가져오는데 실패했습니다.'),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
