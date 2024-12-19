import 'package:intl/intl.dart';

String chatFormatTimestamp(String timestamp) {
  // 문자열을 DateTime 객체로 변환
  final DateTime dateTime = DateTime.parse(timestamp);

  // 원하는 형식으로 포맷
  final String formatted = DateFormat('MM-dd HH:mm').format(dateTime);

  return formatted;
}
