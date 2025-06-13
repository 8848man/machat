part of '../lib.dart';

class ChatProfileIcon extends ConsumerWidget {
  final double size;
  final RoomUserData userData;
  const ChatProfileIcon(
      {super.key, required this.size, required this.userData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chatViewModelProvider.notifier);
    return GestureDetector(
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xff4dabf7),
              Color(0xffda77f2),
              Color(0xfff783ac),
            ],
          ),
          borderRadius: BorderRadius.circular(500),
        ),
        child: const CircleAvatar(
          radius: 250,
          child: Icon(
            Icons.person,
            color: Color(0xffCCCCCC),
            size: 20,
          ),
        ),
      ),
      onTap: () => notifier.goProfile(userData),
    );
  }
}
