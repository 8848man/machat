part of '../lib.dart';

class AddFriend extends ConsumerStatefulWidget {
  const AddFriend({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFriendState();
}

class _AddFriendState extends ConsumerState<AddFriend>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 초기화 작업이 필요하다면 여기에 작성
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      needLogin: true,
      child: Padding(
        padding: MCPadding().vertical(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(),
            MCSpace().verticalHalfSpace(),
            buildTabbar().sizedBox(height: 30, width: double.infinity),
            MCSpace().verticalHalfSpace(),
            buildTabbarView().expand(),
            MCSpace().verticalHalfSpace(),
            // buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: MCPadding().left(),
      child: const Text(
        '친구 추가',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTabbar() {
    return TabBar(
      tabs: const [
        Tab(text: '이메일로 친구 추가'),
        Tab(text: '닉네임으로 친구 추가'),
      ],
      indicatorColor: Colors.blue,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      controller: _tabController,
    );
  }

  Widget buildTabbarView() {
    return TabBarView(
      controller: _tabController,
      children: const [
        SearchFriend(searchBy: FriendSearchBy.email),
        SearchFriend(searchBy: FriendSearchBy.name),
      ],
    );
  }

  Widget buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // buildBackButton(),
        buildAddFriendButton(),
      ],
    );
  }

  Widget buildBackButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('뒤로 가기'),
    );
  }

  Widget buildAddFriendButton() {
    return ElevatedButton(
      onPressed: () {
        // 친구 추가 로직
      },
      child: const Text('친구 추가'),
    );
  }
}
