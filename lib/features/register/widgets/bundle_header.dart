part of '../lib.dart';

class RegisterBundleHeader extends StatelessWidget {
  const RegisterBundleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        McAppear(
          delayMs: 200,
          child: Text(
            '우리의 멤버가',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        McAppear(
          delayMs: 600,
          child: Text(
            '되어주세요',
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
