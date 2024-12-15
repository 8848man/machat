part of '../lib.dart';

class ChatProfile extends StatelessWidget {
  final double size;
  const ChatProfile({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
