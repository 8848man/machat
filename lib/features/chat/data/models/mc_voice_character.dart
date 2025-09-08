import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

/// 내부 DTO
class MCVoiceCharacter {
  final String displayName;
  final String id;
  final String filename;

  MCVoiceCharacter({
    required this.displayName,
    required this.id,
    required this.filename,
  });

  /// 외부 VoiceCharacter → 내부 DTO 변환
  factory MCVoiceCharacter.fromExternal(VoiceCharacter vc) {
    return MCVoiceCharacter(
      displayName: vc.displayName,
      id: vc.id,
      filename: vc.filename,
    );
  }

  /// 커맨드 문자열 생성
  String get commandText => '/character:$displayName';
}

/// 외부 Enum 기준으로 동적 리스트 생성
final List<MCVoiceCharacter> mcCharacters = VoiceCharacter.values
    .map((vc) => MCVoiceCharacter.fromExternal(vc))
    .toList();
