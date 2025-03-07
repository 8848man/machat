import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/expand/enums/expand_state.dart';
import 'package:machat/features/chat/expand/providers/expand_widget_state_provider.dart';
import 'package:machat/features/chat/expand/view_models/chat_image_view_model.dart';
import 'package:machat/features/chat/expand/widgets/chat_picture.dart';
import 'package:machat/features/chat/expand/widgets/chat_upload.dart';

class ChatExpandBrancher extends ConsumerWidget {
  const ChatExpandBrancher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExpandWidgetState state = ref.watch(expandWidgetStateProvider);
    ref.watch(chatImageViewModelProvider);
    switch (state) {
      // 접힌 상태 표현
      case ExpandWidgetState.collapsed:
        return const SizedBox.shrink();
      // 펼쳐진 기본 상태 표현
      case ExpandWidgetState.expanded:
        return const ChatExpandSelector();
      // 사진 선택 상태 표현
      case ExpandWidgetState.picture:
        return const ChatPicture();
      // 예외 상태 표현
      default:
        return Container();
    }
  }
}
