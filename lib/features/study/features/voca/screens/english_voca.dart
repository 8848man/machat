import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/study/common/layouts/draggable_fab_layout.dart';
import 'package:machat/features/study/features/voca/animated_widgets/voca_create_button.dart';
import 'package:machat/features/study/features/voca/providers/voca_tab_provider.dart';
import 'package:machat/features/study/features/voca/widgets/card.dart';
import 'package:machat/features/study/features/voca/widgets/memo_list.dart';
import 'package:machat/features/study/providers/voca_info_provider.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
    ref.watch(nowVocaProvider);
    final index = ref.watch(vocaTabIndexProvider);

    _tabController.animateTo(index);
    return DraggableFabLayout(
      fab: const AnimatedFabButton(),
      child: DefaultLayout(
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
              indicatorWeight: 2,
              controller: _tabController,
              tabs: <Widget>[
                // const Tab(icon: Icon(Icons.book)),
                Tab(
                  icon: SvgPicture.asset(
                    'lib/assets/icons/voca_flash_card.svg',
                    height: 32,
                    width: 32,
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset(
                    'lib/assets/icons/voca_card.svg',
                    height: 32,
                    width: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
