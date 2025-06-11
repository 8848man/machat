part of '../lib.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({super.key});

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  bool showOverlay = false;
  final TextEditingController _nameController = TextEditingController();

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
          child: buildOverlay(),
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
                ).expand(),
                MCSpace().horizontalSpace(),
                ElevatedButton(
                  onPressed: () {
                    setState(() => showOverlay = !showOverlay);
                  },
                  child: const Text('검색'),
                ),
              ],
            ),
            MCSpace().verticalSpace(),
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
                        content: Text('${_nameController.text} 친구 $index 선택됨')),
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
        '"${_nameController.text}"(으)로 검색된 친구',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
