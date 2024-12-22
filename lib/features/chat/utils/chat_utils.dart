part of '../lib.dart';

bool shouldHideTimeAndProfile(List<dynamic> messages, int currentIndex) {
  if (currentIndex >= messages.length - 1) return false;

  final currentTimestamp =
      chatFormatTimestamp(messages[currentIndex]['createdAt']);
  final nextTimestamp =
      chatFormatTimestamp(messages[currentIndex + 1]['createdAt']);

  return currentTimestamp == nextTimestamp;
}
