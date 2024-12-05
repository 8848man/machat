part of '../lib.dart';

class RegisterBundle extends StatelessWidget {
  const RegisterBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
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
    );
  }
}
