import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final chatImageRepositoryProvider = Provider<ChatImageRepository>((ref) {
  return ChatImageRepository(ref);
});

class ChatImageRepository implements RepositoryService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseStorage storage;

  ChatImageRepository(this.ref);

  // 이미지 업로드 + Firestore 저장
  Future<String?> uploadImage(
      String senderId, String roomId, XFile image) async {
    try {
      // 현재 시간 기준으로 파일 이름 만들기
      String fileName = "chat_${DateTime.now().millisecondsSinceEpoch}.jpg";
      // 스토리지 저장소 레퍼런스
      Reference storageRef = _storage.ref().child('chat_images/$fileName');

      // `XFile`을 바이트로 변환
      Uint8List bytes = await image.readAsBytes();

      // storage에 업로드 후 URL 가져오기
      UploadTask uploadTask = storageRef.putData(bytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      // 가져온 URL을 기반으로 Firestore에 저장
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('images')
          .add({
        'imageUrl': downloadURL,
        'createdBy': senderId,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'image'
      });

      return downloadURL;
    } catch (e) {
      print("이미지 업로드 실패: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id, {String? userId}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> readAll({String? searchId}) {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
