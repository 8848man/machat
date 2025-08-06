import 'package:flutter/material.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat_token_service/design_system/lib.dart';

class MemoCard extends StatefulWidget {
  final int index;
  final bool Function()? onTap;
  final WordModel data;

  const MemoCard({
    super.key,
    required this.index,
    this.onTap,
    required this.data,
  });

  @override
  State<MemoCard> createState() => _MemoCardState();
}

class _MemoCardState extends State<MemoCard> {
  bool isTranslated = false;

  String getTitle() {
    if (!isTranslated) return 'English';

    return '한국어';
  }

  String getWord() {
    if (!isTranslated) return widget.data.word;

    return widget.data.meaning;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      getTitle(),
                      style: TextStyle(
                          color: MCColors.$color_grey_10, fontSize: 18),
                    ),
                    MCSpace().horizontalHalfSpace(),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isTranslated = !isTranslated;
                          });
                        },
                        child: const Icon(Icons.sync, size: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  getWord(),
                  // "test!${widget.index}",
                  style:
                      TextStyle(color: MCColors.$color_grey_100, fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
