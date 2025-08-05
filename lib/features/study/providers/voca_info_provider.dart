import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';

final nowVocaProvider =
    StateProvider<VocabularyModel>((ref) => const VocabularyModel());
