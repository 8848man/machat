import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';

final drawerRepositoryProvider = Provider<RepositoryService>((ref) {
  return DrawerRepository();
});

class DrawerRepository implements RepositoryService {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(String id) async {
    try {
      // Firestore 컬렉션에서 유저 문서를 가져오기
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      // 문서가 존재하지 않는 경우 처리
      if (!doc.exists) {
        throw Exception('User not found');
      }

      // 데이터를 반환 (doc.data()는 Map<String, dynamic>? 타입이므로 null 방지)
      return doc.data()!;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readAll() {
    // TODO: implement readAll
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}