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

// 메시지가 전체 삭제된 경우, 해당 메시지를 숨김 처리합니다.
// 작성자가 차단되었을 경우, 해당 메시지를 숨김 처리합니다.
// 내가 해당 메세지를 나에게만 삭제할 경우, 해당 메시지를 숨김 처리합니다.
bool isHiddenChat(dynamic message, String userId, String senderId) {
  // 전체 삭제된 메시지는 무조건 숨김
  if (message['isDeletedForEveryone'] == true) {
    return true;
  }

  // 작성자가 차단된 경우의 메시지 숨김 처리 로직 구현

  // deletedTo가 null이거나 없을 수도 있으니 안전하게 처리
  final deletedTo = (message['deletedTo'] ?? []) as List<dynamic>;

  return deletedTo.contains(userId);
}
