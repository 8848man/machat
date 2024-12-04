part of '../lib.dart';

class LoginBundle extends StatelessWidget {
  const LoginBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoginBundleHeader(),
          LoginBundleBody(),
          LoginBundleFooter(),
        ],
      ),
    );
  }
}
