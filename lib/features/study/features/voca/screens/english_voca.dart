import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/study/features/voca/providers/voca_tab_provider.dart';
import 'package:machat/features/study/features/voca/widgets/card.dart';
import 'package:machat/features/study/features/voca/widgets/memo_list.dart';

class EnglishVoca extends ConsumerStatefulWidget {
  const EnglishVoca({super.key});

  @override
  ConsumerState<EnglishVoca> createState() => _EnglishVocaState();
}

class _EnglishVocaState extends ConsumerState<EnglishVoca>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      ref.read(vocaTabIndexProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(vocaTabIndexProvider);

    _tabController.animateTo(index);
    return DefaultLayout(
      needLogin: true,
      child: Column(
        children: [
          TabBarView(
            controller: _tabController,
            children: const <Widget>[
              VocaMemoList(),
              VocaCard(),
            ],
          ).expand(),
          TabBar(
            indicatorWeight: 3,
            controller: _tabController,
            tabs: <Widget>[
              const Tab(icon: Icon(Icons.book)),
              Tab(
                icon: SvgPicture.asset(
                  'lib/assets/icons/voca_card.svg',
                  height: 24,
                  width: 24,
                ),
              ),
              //lib/assets/icons/voca_card.svg
            ],
          ),
        ],
      ),
    );
  }
}
