part of '../lib.dart';

class RegisterBundle extends StatelessWidget {
  const RegisterBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RegisterBundleHeader(),
          RegisterBundleBody(),
          RegisterBundleFooter(),
        ],
      ),
    );
  }
}
