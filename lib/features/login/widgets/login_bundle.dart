part of '../lib.dart';

class LoginBundle extends StatelessWidget {
  const LoginBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return BundleLayout(
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
    );
  }
}
