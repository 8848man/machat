import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/ai/ai_model.dart';

final selectedCharacterProvider = StateProvider<AiModel?>((ref) => null);
