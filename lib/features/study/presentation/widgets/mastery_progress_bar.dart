import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

class MasteryProgressBar extends StatelessWidget {
  final double knowRate; // 0~1
  final double confusedRate; // 0~1
  // final double masteredRate; // 0~1

  const MasteryProgressBar({
    super.key,
    required this.knowRate,
    required this.confusedRate,
    // required this.masteredRate,
  });

  @override
  Widget build(BuildContext context) {
    final total = knowRate + confusedRate;
    final mediaWidth = MediaQuery.of(context).size.width;
    // + masteredRate;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: SizedBox(
        width: mediaWidth < 440 ? 100 : 200,
        height: 10,
        child: Row(
          children: [
            Expanded(
              flex: (knowRate * 1000).toInt(),
              child: Container(color: MCColors.$color_blue_30),
            ),
            Expanded(
              flex: (confusedRate * 1000).toInt(),
              child: Container(color: MCColors.$color_orange_30),
            ),
            if (total < 1.0)
              Expanded(
                flex: ((1 - total) * 1000).toInt(),
                child: Container(color: Colors.grey[300]),
              ),
          ],
        ),
      ),
    );
  }
}
