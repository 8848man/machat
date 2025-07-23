part of '../lib.dart';

class SearchFriend extends ConsumerStatefulWidget {
  final FriendSearchBy searchBy;
  const SearchFriend({super.key, this.searchBy = FriendSearchBy.name});

  @override
  ConsumerState<SearchFriend> createState() => _SearchFriendState();
}

class _SearchFriendState extends ConsumerState<SearchFriend> {
  bool showOverlay = false;
  bool _isPopping = false;

  late final AddFriendViewModel _viewModel;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    _viewModel = ref.read(addFriendViewModelProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mcPopScope(
      context: context,
      onPopInvoked: (didPop) {
        if (!didPop) {
          popOverlay();
        }
      },
      child: Stack(
        children: [
          // 1. 기존 콘텐츠
          if (widget.searchBy == FriendSearchBy.name) _buildSearchByName(),
          if (widget.searchBy == FriendSearchBy.email) _buildSearchByEmail(),

          // 2. 애니메이션 오버레이
          // 검색된 친구들 위젯
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: 0,
            bottom: 0,
            left: showOverlay ? 0 : MediaQuery.of(context).size.width,
            right: showOverlay ? 0 : -MediaQuery.of(context).size.width,
            child: SearchedFriends(onPopOverlay: popOverlay),
          ),
        ],
      ),
    );
  }

  /// 기존 콘텐츠 (A 위젯 역할)
  Widget _buildSearchByName() {
    return BundleLayout(
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
                controller: _inputController,
                onSubmitted: (value) async {
                  await _viewModel.searchByNickname(_inputController.text);
                  openOverlay();
                },
              ).expand(),
              MCSpace().horizontalSpace(),
              MCButtons().getPositiveButton(
                width: 100,
                title: '검색',
                onTap: () async {
                  await _viewModel.searchByNickname(_inputController.text);
                  openOverlay();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchByEmail() {
    return BundleLayout(
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
                controller: _inputController,
                onSubmitted: (value) async {
                  await _viewModel.searchByEmail(_inputController.text);
                  openOverlay();
                },
              ).expand(),
              MCSpace().horizontalSpace(),
              MCButtons().getPositiveButton(
                width: 100,
                title: '검색',
                onTap: () async {
                  await _viewModel.searchByEmail(_inputController.text);
                  openOverlay();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void openOverlay() {
    setState(() {
      showOverlay = true;
    });
  }

  void popOverlay() {
    if (_isPopping) return; // 이미 실행 중이면 무시
    _isPopping = true;

    setState(() {
      if (showOverlay == false) {
        final router = ref.read(goRouterProvider);
        router.goNamed(RouterPath.home.name);
        return;
      }

      showOverlay = false;
    });

    // 약간의 지연 후에 다시 활성화
    Future.delayed(const Duration(milliseconds: 500), () {
      _isPopping = false;
    });
  }
}
