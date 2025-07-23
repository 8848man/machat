import 'package:flutter/material.dart';

class BundleLayout extends StatelessWidget {
  final Widget child;
  const BundleLayout({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: 400,
                ),
                child: IntrinsicHeight(
                  // 자식 Column이 최소 높이를 기준으로 꽉 차도록
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
