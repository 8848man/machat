import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/features/voca/enums/voca_sorted_by.dart';

final vocaSortedByProvider = Provider<VocaSortedBy>((ref) {
  return VocaSortedBy.createdAt;
});
