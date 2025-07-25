part of '../lib.dart';

class LoginBundle extends StatelessWidget {
  const LoginBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoginBundleHeader(),
          MCSpace().verticalSpace(),
          const LoginBundleBody(),
          MCSpace().verticalSpace(),
          const LoginBundleFooter(),
        ],
      ),
    );
  }
}
