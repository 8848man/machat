part of '../lib.dart';

class SearchedFriends extends ConsumerWidget {
  final VoidCallback onToggleOverlay;
  const SearchedFriends({super.key, required this.onToggleOverlay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AddFriendModel userList = ref.watch(addFriendViewModelProvider);
    return Container(
      color: Colors.white.withOpacity(0.8),
      alignment: Alignment.center,
      child: Column(
        children: [
          buildOverlayTitle(),
          MCSpace().verticalSpace(),
          buildUser(ref, userList.users).expand(),
          MCSpace().verticalSpace(),
          ElevatedButton(
            onPressed: () {
              onToggleOverlay();
            },
            child: const Text('뒤로가기'),
          ),
        ],
      ),
    );
  }

  Widget buildUser(WidgetRef ref, List<UserData> userList) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userList.length, // 예시로 10개의 친구를 표시
      itemBuilder: (context, index) {
        final UserData friend = userList[index];
        return buildInfo(user: friend, ref: ref, context: context);
      },
    );
  }

  Widget buildOverlayTitle() {
    return Padding(
      padding: MCPadding().left(),
      child: const Text(
        '찾으시는 친구가 있으신가요?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
