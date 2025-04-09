part of '../lib.dart';

// class HomeBundle extends StatelessWidget {
//   const HomeBundle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('당신이 원하는 모든 채팅'),
//           Text('마챗에 오신걸 환영합니다!'),
//         ],
//       ),
//     );
//   }
// }

class HomeBundle extends ConsumerStatefulWidget {
  const HomeBundle({super.key});

  @override
  ConsumerState<HomeBundle> createState() => _HomeBundleState();
}

class _HomeBundleState extends ConsumerState<HomeBundle>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Firends(),
            HomeChatList(),
            Center(child: Text("해당 기능은 준비중입니다.")),
          ],
        ).expand(),
        TabBar(
          indicatorWeight: 3,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(IconData(0xe153, fontFamily: 'MaterialIcons'))),
            Tab(icon: Icon(Icons.brightness_5_sharp)),
          ],
        ),
      ],
    );
  }
}
