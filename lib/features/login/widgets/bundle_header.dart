part of '../lib.dart';

class LoginBundleHeader extends StatelessWidget {
  const LoginBundleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        McAppear(
          child: Text(
            '마챗에 오신걸',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        McAppear(
          delayMs: 400,
          child: Text(
            '환영합니다',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
