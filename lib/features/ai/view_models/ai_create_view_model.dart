import 'package:machat/features/ai/models/ai_model.dart';
import 'package:machat/features/ai/repositories/ai_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_create_view_model.g.dart';

@riverpod
class AiCreateViewModel extends _$AiCreateViewModel {
  @override
  Future<void> build() async {
    ref.onDispose(() {
      // _tts.dispose();
    });
    return;
  }

  Future<bool> createCharacter(AiModel model) async {
    final repo = ref.read(aiRepositoryProvider);
    final result = await repo.createCharacter(model);
    return result != null;
  }
}
