import 'package:freezed_annotation/freezed_annotation.dart';

part 'members.freezed.dart';
part 'members.g.dart';

@freezed
class MemberList with _$MemberList {
  const factory MemberList({
    required List<Member> memberList,
  }) = _MemberList;

  factory MemberList.fromJson(Map<String, dynamic> json) =>
      _$MemberListFromJson(json);
}

@freezed
class Member with _$Member {
  const factory Member({
    required String id,
    required DateTime eterTime,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
