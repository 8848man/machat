import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rwkim_tts/rwkim_tts.dart';

final simpleTTSProvider = Provider<SimpleTTS>((ref) {
  return SimpleTTS(baseUrl: 'https://supertone-api.onrender.com');
});
