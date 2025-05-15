import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/repository/chat_contents_repository.dart';

class ChatContentsViewModel extends StateNotifier<List<Map<String, dynamic>>> {
  ChatContentsViewModel(this._repo, this._roomId, this._entryTime) : super([]) {
    _init();
  }

  final ChatContentsRepository _repo;
  final String _roomId;
  final DateTime _entryTime;

  StreamSubscription? _streamSub;

  Future<void> _init() async {
    // 1. 초기 데이터 가져오기
    final initialMessages = await _repo.getInitialChats(_roomId);
    state = [...initialMessages];

    // 2. 이후 메시지 실시간 수신
    _streamSub =
        _repo.subscribeToNewChats(_roomId, _entryTime).listen((newMessages) {
      state = [...state, ...newMessages]; // 중복 제거 로직 추가 가능
    });
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }
}
