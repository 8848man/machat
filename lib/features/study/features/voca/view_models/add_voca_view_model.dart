import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_voca_view_model.g.dart';

@riverpod
class AddVocaViewModel extends _$AddVocaViewModel {
  @override
  void build() {}

  void getWordInFirebase(String wordString) {
    print('test001! wordString is $wordString');
  }
}
