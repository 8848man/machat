import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/open_chat_list/lib.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      needLogin: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MCColors.$color_blue_40, width: 1),
          ),
          child: ListView(
            children: const [ChatListMobile()],
          ),
        ),
      ),
    );
  }
}
