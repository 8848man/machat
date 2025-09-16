import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

/// Firestore Timestamp / String / int / DateTime 를 안전히 DateTime? 으로 변환
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is DateTime) return json;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.tryParse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    if (object == null) return null;
    // Firestore에 저장할 때 Timestamp로 넣고 싶으면 아래 반환을 사용하세요:
    return Timestamp.fromDate(object);
    // 혹은 JSON 전송용으로 문자열을 원하면:
    // return object.toIso8601String();
  }
}

String parseCreatedAt(dynamic raw) {
  if (raw == null) return '';
  if (raw is String) return raw;
  if (raw is DateTime) return raw.toIso8601String();
  if (raw is Timestamp) return raw.toDate().toIso8601String();
  if (raw is int) {
    return DateTime.fromMillisecondsSinceEpoch(raw).toIso8601String();
  }
  if (raw is FieldValue) return ''; // 아직 서버에서 채워지지 않은 상태
  return '';
}
