part of '../lib.dart';

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
    _tabController.addListener(() {
      ref.read(tabIndexProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(tabIndexProvider);

    _tabController.animateTo(index);
    return Column(
      children: [
        TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Friends(),
            HomeChatList(),
            EarnPointBundle(),
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
