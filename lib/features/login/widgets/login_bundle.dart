part of '../lib.dart';

class LoginBundle extends StatelessWidget {
  const LoginBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                // 자식 Column이 최소 높이를 기준으로 꽉 차도록
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginBundleHeader(),
                    const SizedBox(height: 50),
                    const LoginBundleBody(),
                    MCSpace().verticalSpace(),
                    const LoginBundleFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
