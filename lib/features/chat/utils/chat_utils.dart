part of '../lib.dart';

bool shouldHideTime(List<dynamic> messages, int currentIndex) {
  // 현재 인덱스가 마지막 메시지라면 시간을 숨기지 않음
  if (currentIndex >= messages.length - 1) return false;

  final String currentTimestamp =
      chatFormatTimestamp(messages[currentIndex]['createdAt']);
  final String nextTimestamp =
      chatFormatTimestamp(messages[currentIndex + 1]['createdAt']);

  final String currentSender = messages[currentIndex]['createdBy'];
  final String nextSender = messages[currentIndex + 1]['createdBy'];

  // 다음 메시지와 시간이 같고, 같은 사람이 보낸 경우 시간 숨김
  if (currentTimestamp == nextTimestamp && currentSender == nextSender) {
    return true;
  }

  return false;
}

// 이전 메세지를 보낸 사람과 현재 메세지를 보낸 사람이 같은 경우 프로필 숨김
bool shouldHideProfile(List<dynamic> messages, int currentIndex) {
  if (currentIndex - 1 < 0) return false;

  final String currentSender = messages[currentIndex]['createdBy'];
  final String nextSender = messages[currentIndex - 1]['createdBy'];

  return currentSender == nextSender;
}
