part of '../lib.dart';

class ChatCreate extends StatelessWidget {
  const ChatCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      needLogin: true,
      child: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChatCreateHeader(),
              MCSpace().verticalSpace(),
              const ChatCreateBody(),
              MCSpace().verticalSpace(),
              const ChatCreateFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
