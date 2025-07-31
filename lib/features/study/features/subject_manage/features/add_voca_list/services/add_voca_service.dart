import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final chatRoomCrudProvider = Provider<AddVocaService>((ref) {
  final firestore = FirebaseFirestore.instance;
  return AddVocaService(firestore);
});

class AddVocaService {
  final FirebaseFirestore _firestore;

  AddVocaService(this._firestore);

  Future<void> saveVocabularyTransaction() async {}
}
