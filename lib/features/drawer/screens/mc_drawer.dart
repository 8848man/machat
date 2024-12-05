part of '../lib.dart';

class MCDrawer extends ConsumerWidget {
  const MCDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mCDrawerViewModelProvider.notifier);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerProfile(),
          ListTile(
            title: const Text('홈'),
            onTap: () => notifier.goHome(),
          ),
          const Divider(),
          ListTile(
            title: const Text('chatRoomName'),
            onTap: () => notifier.goChat(),
          ),
        ],
      ),
    );
  }
}
