import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/models/ai/ai_model.dart';
import 'package:machat/features/ai/view_models/ai_character_list_view_model.dart';

class AiHomeBody extends ConsumerWidget {
  const AiHomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiCharacterListViewModelProvider);
    return state.when(
      error: (error, StackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      data: (data) {
        print(data.models.length);
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            children: List.generate(data.models.length, (index) {
              final aiData = data.models[index];
              return aiListCard(aiData);
            }),
          ),
        );
      },
    );
  }

  Widget aiListCard(AiModel aiData) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        color: MCColors.$color_grey_10,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(aiData.name),
              Text(aiData.traits.toString()),
              Text(aiData.description.toString()),
              Text(aiData.prompt ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
