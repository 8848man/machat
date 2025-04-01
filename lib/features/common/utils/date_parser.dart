// createdAt 필드를 파싱하는 메서드
import 'package:cloud_firestore/cloud_firestore.dart';

String? parseDateToString(dynamic createdAt) {
  if (createdAt == null) {
    return null;
  } else if (createdAt is Timestamp) {
    // Firebase Timestamp인 경우
    return createdAt.toDate().toString();
  } else if (createdAt is String) {
    // ISO 8601 문자열인 경우
    return DateTime.parse(createdAt).toString();
  } else {
    throw UnsupportedError('Unsupported createdAt format');
  }
}
