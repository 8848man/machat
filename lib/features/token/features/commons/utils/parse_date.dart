import 'package:cloud_firestore/cloud_firestore.dart';

DateTime parseDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  } else {
    return DateTime.now();
  }
}
