import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/drawer/models/drawer_model.dart';
import 'package:machat/features/drawer/repository/drawer_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mc_drawer_view_model.g.dart';

@riverpod
class MCDrawerViewModel extends _$MCDrawerViewModel {
  List<ChatRoomData> chatRooms = [];
  @override
  Future<DrawerModel> build() async {
    final DrawerModel data = await initData();

    return data;
  }

  Future<DrawerModel> initData() async {
    final repository = ref.read(drawerRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    if (user == null) return const DrawerModel();

    // 현재 로그인된 유저 uid로 유저 정보 가져오기
    // 후에 캐싱처리하도록 개선
    final userData = await repository.read(user.uid);

    // 가져온 유저 정보를 파싱
    final UserData userProfile = UserData.fromJson(userData);

    final List<ChatRoomData> chatRooms = await getChatRooms();

    return DrawerModel(user: userProfile, roomList: chatRooms);
  }

  Future<List<ChatRoomData>> getChatRooms() async {
    final repository = ref.read(drawerRepositoryProvider);
    try {
      // 현재 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      // Repository 호출
      final rawChatRooms = await repository.readAll(searchId: userId);

      // Firestore 데이터를 ChatRoomData로 변환
      List<ChatRoomData> chatRooms = rawChatRooms.map((data) {
        return ChatRoomData.fromJson({
          'roomId': data['roomId'],
          'name': data['name'],
          'createdBy': data['createdBy'],
          'members': data['members'],
          'createdAt': (data['createdAt'] as Timestamp)
              .toDate()
              .toString(), // Timestamp를 DateTime으로 변환
          'isMine': data['createdBy'] == userId, // 내가 만든 방인지 추가
        });
      }).toList();

      return chatRooms;
    } catch (e) {
      // 에러 처리
      print('Error fetching chat rooms: $e');
      return [];
    }
  }

  Future<void> deleteChatRoom() async {}

  /// routing
  void goHome() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.home.name);
  }

  void goLogin() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }

  void goChat() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.chat.name);
  }

  /// routing/
}
