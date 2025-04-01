library mc_chat;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/chat/expand/enums/chat_contents_type.dart';
import 'package:machat/features/chat/expand/enums/expand_state.dart';
import 'package:machat/features/chat/expand/providers/expand_widget_state_provider.dart';
import 'package:machat/features/chat/expand/view_models/chat_image_view_model.dart';
import 'package:machat/features/chat/expand/widgets/chat_expand_brancher.dart';
import 'package:machat/features/chat/interface/chat_view_model_interface.dart';
import 'package:machat/features/chat/models/chat.dart';
import 'package:machat/features/chat/models/image.dart';
import 'package:machat/features/chat/providers/chat_focus_node_provider.dart';
import 'package:machat/features/chat/providers/chat_message_group_provider.dart';
import 'package:machat/features/chat/providers/chat_sending_widget_proivder.dart';
import 'package:machat/features/chat/view_models/chat_view_model.dart';
import 'package:machat/features/chat/widgets/chat_image.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/utils/completer.dart';
import 'package:machat/features/common/utils/extractor.dart';
import 'package:machat/features/common/utils/loading_overtime.dart';

part 'screens/chat.dart';
part './widgets/chat_input.dart';
part './widgets/chat_profile.dart';
part './widgets/chat_bubble.dart';
part './utils/chat_utils.dart';
part 'expand/widgets/chat_expand.dart';
part 'widgets/chat_contents.dart';
part './widgets/chat_sending_contents.dart';
