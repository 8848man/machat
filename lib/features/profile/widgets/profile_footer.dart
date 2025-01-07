import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [MCSpace().verticalHalfSpace(), const Divider()],
    );
  }
}
