part of '../lib.dart';

class RegisterBundle extends StatelessWidget {
  const RegisterBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return BundleLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RegisterBundleHeader(),
          const SizedBox(height: 50),
          const RegisterBundleBody(),
          MCSpace().verticalSpace(),
          const RegisterBundleFooter(),
        ],
      ),
    );
  }
}
