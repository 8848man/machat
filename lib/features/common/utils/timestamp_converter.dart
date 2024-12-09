import 'package:cloud_firestore/cloud_firestore.dart';

// Timestamp -> DateTime 변환 유틸
DateTime? timestampToDateTime(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  if (timestamp is String) {
    return DateTime.tryParse(timestamp);
  }
  return null;
}

// DateTime -> Timestamp 변환
dynamic dateTimeToTimestamp(DateTime? dateTime) {
  return dateTime?.toIso8601String(); // Firestore와 호환되게 문자열로 저장
}
