part of '../lib.dart';

class SearchByEmail extends ConsumerStatefulWidget {
  const SearchByEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchByEmailState();
}

class _SearchByEmailState extends ConsumerState<SearchByEmail> {
  bool showOverlay = false;

  late final AddFriendViewModel _viewModel;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(addFriendViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 기존 콘텐츠
        buildSearchBundle(),

        // 2. 애니메이션 오버레이
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          top: 0,
          bottom: 0,
          left: showOverlay ? 0 : MediaQuery.of(context).size.width,
          right: showOverlay ? 0 : -MediaQuery.of(context).size.width,
          child: SearchedFriends(onToggleOverlay: toggleOverlay),
        ),
      ],
    );
  }

  Widget buildSearchBundle() {
    return Center(
      child: Padding(
        padding: MCPadding().all(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '이메일로 친구를 검색해요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            MCSpace().verticalSpace(),
            Row(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일',
                  ),
                  controller: _emailController,
                  onSubmitted: (value) async {
                    await _viewModel.searchByEmail(_emailController.text);
                    setState(() => showOverlay = !showOverlay);
                  },
                ).expand(),
                MCSpace().horizontalSpace(),
                MCButtons().getPositiveButton(
                  width: 100,
                  title: '검색',
                  onTap: () async {
                    await _viewModel.searchByEmail(_emailController.text);
                    setState(() => showOverlay = !showOverlay);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 회색 오버레이 위젯 (B 위젯 역할)
  Widget buildOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      alignment: Alignment.center,
      child: Column(
        children: [
          buildOverlayTitle(),
          MCSpace().verticalSpace(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 10, // 예시로 10개의 친구를 표시
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('친구 $index'),
                onTap: () {
                  // 친구 선택 시 동작
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('${_emailController.text} 친구 $index 선택됨')),
                  );
                },
              );
            },
          ).expand(),
          MCSpace().verticalSpace(),
          ElevatedButton(
            onPressed: () {
              setState(() => showOverlay = !showOverlay);
            },
            child: const Text('뒤로가기'),
          ),
        ],
      ),
    );
  }

  Widget buildOverlayTitle() {
    return Padding(
      padding: MCPadding().left(),
      child: Text(
        '"${_emailController.text}"(으)로 검색된 친구',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  void toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }
}
