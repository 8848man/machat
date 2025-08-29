import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/ai/ai_model.dart';
import 'package:machat/features/ai/view_models/ai_character_list_view_model.dart';

// final aiCharactersProvider = Provider<AiCharacterFacade>((ref) {
//   // final aiCharacterListViewModel = ref.watch(aiCharacterListViewModelProvider);
//   final vm = ref.watch(aiCharacterListViewModelProvider.notifier);
//   return AiCharacterFacade(vm);
// });
final aiCharactersProvider =
    NotifierProvider<AiCharactersNotifier, AsyncValue<AiModelPage>>(() {
  return AiCharactersNotifier();
});

class AiCharactersNotifier extends Notifier<AsyncValue<AiModelPage>> {
  @override
  AsyncValue<AiModelPage> build() {
    return ref.watch(aiCharacterListViewModelProvider);
  }

  Future<void> fetchMore() async {
    ref.read(aiCharacterListViewModelProvider.notifier).fetchMore();
  }

  // Future<void> refresh() async {
  //   await _facade.refresh();
  // }
}
