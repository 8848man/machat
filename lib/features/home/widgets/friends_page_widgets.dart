part of '../lib.dart';

Widget infoBox({required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
    child: child,
  );
}

Widget buildMyInfo({
  required UserData user,
  required FriendsViewModel notifier,
}) {
  return infoBox(
    child: Row(
      children: [
        gradientAvatar(
          user: user,
          notifier: notifier,
        ),
        const SizedBox(width: 10),
        profileTextColumn(user),
      ],
    ),
  );
}

// 프로필 사진
Widget gradientAvatar({
  required UserData user,
  required FriendsViewModel notifier,
}) {
  return GestureDetector(
    child: Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(4),
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
        radius: 30,
        child: Icon(
          Icons.person,
          color: Color(0xffCCCCCC),
          size: 30,
        ),
      ),
    ),
    onTap: () => notifier.goProfile(),
  );
}

Widget profileTextColumn(UserData user) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(user.name),
      if (user.nationId != null) const Text('한국'),
    ],
  );
}
