import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/presentation/utils/get_by_mastery.dart';
import 'package:machat/features/study/features/voca/presentation/utils/get_string.dart';
import 'package:machat/features/study/features/voca/presentation/view_models/memo_list_view_model.dart';
import 'package:machat_token_service/design_system/lib.dart';
import 'package:machat_token_service/features/commons/providers/loading_state_provider.dart';

class VocaFlashCard extends ConsumerStatefulWidget {
  final int index;
  final bool Function()? onTap;
  final WordModel wordData;

  const VocaFlashCard({
    super.key,
    required this.index,
    this.onTap,
    required this.wordData,
  });

  @override
  ConsumerState<VocaFlashCard> createState() => _VocaFlashCardState();
}

class _VocaFlashCardState extends ConsumerState<VocaFlashCard> {
  bool isTranslated = false;
  bool isDeleting = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(); // 함수 호출 추가!!
            }
            setState(() {});
          },
          child: SizedBox(
            child: Card(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: MCColors.$color_blue_10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          getTitle(isTranslated),
                          style: TextStyle(
                            color: MCColors.$color_grey_10,
                            fontSize: 18,
                          ),
                        ),
                        MCSpace().horizontalHalfSpace(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isTranslated = !isTranslated;
                            });
                          },
                          child: const Icon(Icons.sync, size: 24),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isDeleting = !isDeleting;
                            });
                          },
                          child: const Icon(Icons.close, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        getWord(isTranslated, widget.wordData),
                        style: TextStyle(
                          color: MCColors.$color_grey_100,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis, // 넘치면 ... 처리
                        maxLines: 1, // 한 줄까지만 표시
                        softWrap: false, // 줄바꿈 안 하고 잘림 처리
                      ),
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await ref
                                  .read(memoListViewModelProvider.notifier)
                                  .changeMastery(widget.wordData);
                            } catch (e) {
                              // Handle error
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  getMasteryColor(widget.wordData.masteryLevel),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: buildMastery(widget.wordData.masteryLevel),
                            ),
                          ),
                        ),
                        if (isLoading)
                          Positioned.fill(
                            child: Container(
                              width: 10,
                              height: 10,
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // --- 삭제 애니메이션 오버레이 ---
        IgnorePointer(
          ignoring: !isDeleting,
          child: AnimatedOpacity(
            opacity: isDeleting ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDeleting = !isDeleting;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "이 단어를 삭제하시겠어요?",
                      style: TextStyle(color: MCColors.$color_grey_00),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(memoListViewModelProvider.notifier)
                            .deleteWord(widget.wordData);
                        setState(() {
                          isDeleting = !isDeleting;
                        });
                      },
                      child: Consumer(builder: (context, ref, child) {
                        final bool isLoading = ref.watch(loadingStateProvider);
                        return isLoading == true
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.delete,
                                color: Colors.white, size: 40);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMastery(WordMasteryLevel mLevel) {
    switch (mLevel) {
      case WordMasteryLevel.unknown:
        return const Text("😔 몰라요", style: TextStyle(fontSize: 16));
      case WordMasteryLevel.confused:
        return const Text("😕 헷갈려요", style: TextStyle(fontSize: 16));
      case WordMasteryLevel.mastered:
        return const Text("😎 외웠어요!", style: TextStyle(fontSize: 16));
    }
  }
}
