part of '../lib.dart';

class HomeBundle extends StatelessWidget {
  const HomeBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('당신이 원하는 모든 채팅'),
        Text('마챗에 오신걸 환영합니다!'),
      ],
    );
  }
}
