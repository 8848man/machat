part of '../lib.dart';

class FriendListWidget extends ConsumerWidget {
  const FriendListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<FriendListModel> state =
        ref.watch(friendListViewModelProvider);

    state.when(
      data: (data) {
        print('test003, data is $data');
        // return ListView.builder(
        //   itemCount: data.friends.length,
        //   itemBuilder: (context, index) {
        //     final friend = data.friends[index];
        //     return ListTile(
        //       title: Text(friend.name),
        //       subtitle: Text(friend.status),
        //       leading: CircleAvatar(
        //         backgroundImage: NetworkImage(friend.profileImageUrl),
        //       ),
        //       onTap: () {
        //         // Handle friend tap
        //       },
        //     );
        //   },
        // );
        return Container();
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

    return Container();
  }
}
