import 'package:machat/features/common/models/ai/ai_model.dart';
import 'package:machat/features/ai/presentation/providers/ai_orderby_type_provider.dart';
import 'package:machat/features/ai/data/repositories/ai_repository.dart';
import 'package:machat/features/ai/presentation/enums/ai_orderby_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_character_list_view_model.g.dart';

@riverpod
class AiCharacterListViewModel extends _$AiCharacterListViewModel {
  @override
  Future<AiModelPage> build() async {
    ref.onDispose(() {
      // _tts.dispose();
    });

    return initState;
  }

  Future<AiModelPage> get initState async {
    final repo = ref.read(aiRepositoryProvider);
    final initialModels = await repo.getAllCharacter(
        limit: 20,
        orderBy: ref.read(aiOrderByTypeProvider).value,
        startAfterDoc: null);
    return initialModels;
  }

  Future<void> fetchMore() async {
    update((state) async {
      final AiModelPage currentState = state;
      if (currentState.lastDoc == null) {
        return state; // 더 이상 로딩할 데이터 없음
      }

      try {
        final repo = ref.read(aiRepositoryProvider);
        final nextPage = await repo.getAllCharacter(
          limit: 10,
          orderBy: AiOrderByType.name.value,
          startAfterDoc: currentState.lastDoc,
        );

        // 이전 모델 리스트 + 신규 모델 리스트 병합
        final merged = currentState.copyWith(
          models: [...currentState.models, ...nextPage.models],
          lastDoc: nextPage.lastDoc,
        );

        return state.copyWith(
          models: merged.models,
          lastDoc: merged.lastDoc,
        );
      } catch (e) {
        return state;
      }
    });
  }
}
