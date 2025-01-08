library mc_chat;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/chat/models/chat.dart';
import 'package:machat/features/chat/providers/chat_message_provider.dart';
import 'package:machat/features/chat/view_models/chat_view_model.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/utils/completer.dart';
import 'package:machat/features/common/utils/extractor.dart';
import 'package:machat/features/common/utils/loading_overtime.dart';

part 'screens/chat.dart';
part './widgets/chat_contents.dart';
part './widgets/chat_input.dart';
part './widgets/chat_profile.dart';
part './widgets/chat_bubble.dart';
part './utils/chat_utils.dart';
