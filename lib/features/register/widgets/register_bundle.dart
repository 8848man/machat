part of '../lib.dart';

class RegisterBundle extends StatelessWidget {
  const RegisterBundle({super.key});

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
                    const RegisterBundleHeader(),
                    MCSpace().verticalSpace(),
                    const RegisterBundleBody(),
                    MCSpace().verticalSpace(),
                    const RegisterBundleFooter(),
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
