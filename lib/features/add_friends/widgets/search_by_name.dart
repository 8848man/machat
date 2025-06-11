part of '../lib.dart';

class SearchByName extends ConsumerStatefulWidget {
  const SearchByName({super.key});

  @override
  ConsumerState<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends ConsumerState<SearchByName> {
  bool showOverlay = false;
  late final AddFriendViewModel _viewModel;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _viewModel = ref.read(addFriendViewModelProvider.notifier);
    super.initState();
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
          child: SearchedFriends(
            onToggleOverlay: toggleOverlay,
          ),
        ),
      ],
    );
  }

  /// 기존 콘텐츠 (A 위젯 역할)
  Widget buildSearchBundle() {
    return Center(
      child: Padding(
        padding: MCPadding().all(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '이름으로 친구를 검색해요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            MCSpace().verticalSpace(),
            Row(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름',
                  ),
                  controller: _nameController,
                  onSubmitted: (value) async {
                    await _viewModel.searchByNickname(_nameController.text);
                    setState(() => showOverlay = !showOverlay);
                  },
                ).expand(),
                MCSpace().horizontalSpace(),
                MCButtons().getPositiveButton(
                  width: 100,
                  title: '검색',
                  onTap: () async {
                    await _viewModel.searchByNickname(_nameController.text);
                    setState(() => showOverlay = !showOverlay);
                  },
                ),
              ],
            ),
            MCSpace().verticalSpace(),
          ],
        ),
      ),
    );
  }

  void toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }
}
