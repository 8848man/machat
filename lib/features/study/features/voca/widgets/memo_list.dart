import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/features/voca/animated_widgets/animated_wheel_card.dart';
import 'package:machat/features/study/features/voca/models/memo_list_model.dart';
import 'package:machat/features/study/features/voca/view_models/memo_list_view_model.dart';
import 'package:machat/features/study/features/voca/widgets/memo_card.dart';

class VocaMemoList extends ConsumerWidget {
  const VocaMemoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MemoListModel> state =
        ref.watch(memoListViewModelProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return const Center(
          child: Text(
            "이런! 에러가 발생했어요!\n다시 접근해주세요!",
            textAlign: TextAlign.center,
          ),
        );
      },
      data: (data) => AnimatedWheelCardView(
        length: data.wordList.length,
        itemBuilder: (context, index, isFocused, goToIndex) {
          return MemoCard(
            index: index,
            data: data.wordList[index],
            // isFocused: isFocused,
            onTap: goToIndex, // 누르면 바로 이동
          );
        },
      ),
    );
  }
}
