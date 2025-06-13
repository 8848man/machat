// 프로필 사진
import 'package:flutter/material.dart';
import 'package:machat/features/common/models/user_data.dart';

Widget gradientAvatar(
    {double? size, required UserData user, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: size ?? 100,
      width: size ?? 100,
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
      child: CircleAvatar(
        radius: 30,
        child: user.profileUrl != null
            ? Image.network(user.profileUrl!, fit: BoxFit.cover)
            : Icon(
                Icons.person,
                color: const Color(0xffCCCCCC),
                size: size != null ? size - 20 : 50,
              ),
      ),
    ),
  );
}
