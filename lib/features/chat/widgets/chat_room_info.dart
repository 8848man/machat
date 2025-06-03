import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';

class ChatRoomInfo extends ConsumerWidget {
  const ChatRoomInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              ref.watch(chatRoomNameProvider),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text('Room Name'),
                  subtitle: Text(ref.watch(chatRoomNameProvider)),
                ),
                ListTile(
                  title: Text('Created By'),
                  subtitle: Text('User Name'), // Replace with actual user name
                ),
                ListTile(
                  title: Text('Created At'),
                  subtitle: Text(
                      DateTime.now().toString()), // Replace with actual date
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
