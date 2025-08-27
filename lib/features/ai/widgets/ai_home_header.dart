import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/router/lib.dart';

class AiHomeHeader extends ConsumerWidget {
  const AiHomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            McAppear(
              delayMs: 200,
              child: Text(
                '등록된 AI 캐릭터를',
                style: TextStyle(
                    color: MCColors.$color_blue_70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            McAppear(
              delayMs: 600,
              child: Text(
                '확인합니다.',
                style: TextStyle(
                    color: MCColors.$color_blue_70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            ref.read(goRouterProvider).goNamed(RouterPath.aiAdd.name);
          },
          child: McAppear(
            delayMs: 1000,
            child: Row(
              children: [
                Text(
                  '캐릭터 생성',
                  style: TextStyle(
                      color: MCColors.$color_blue_70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 54,
                  color: MCColors.$color_blue_50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
