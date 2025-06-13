part of '../lib.dart';

Widget infoBox({required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
    child: child,
  );
}

Widget buildInfo({
  required BuildContext context,
  required UserData user,
  required WidgetRef ref,
}) {
  final FriendsViewModel notifier = ref.read(friendsViewModelProvider.notifier);
  return infoBox(
    child: Row(
      children: [
        gradientAvatar(
            size: 50,
            user: user,
            onTap: () {
              notifier.setProfile(user);
              showProfile(context, ref, user);
            }),
        const SizedBox(width: 10),
        profileTextColumn(user),
      ],
    ),
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
