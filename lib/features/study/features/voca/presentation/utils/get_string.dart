import 'package:machat/features/study/features/voca/models/word_model.dart';

String getTitle(bool isTranslated) {
  if (!isTranslated) return 'English';

  return '한국어';
}

String getWord(bool isTranslated, WordModel modelData) {
  if (!isTranslated) return modelData.word;

  return modelData.meanings.join(', ');
}
