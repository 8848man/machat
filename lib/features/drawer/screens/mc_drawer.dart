part of '../lib.dart';

class MCDrawer extends StatelessWidget {
  const MCDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: const [
          DrawerProfile(),
          DrawerRouter(),
          Divider(),
          DrawerChatList(),
        ],
      ),
    );
  }
}
