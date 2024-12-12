library mc_chat_list;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat_list/models/chat_list_model.dart';
import 'package:machat/features/chat_list/view_models/chat_list_view_model.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/utils/get_color.dart';
import 'package:machat/router/lib.dart';
import 'package:toastification/toastification.dart';

part './widgets/mobile.dart';
part './screens/chat_list.dart';
part './widgets/web.dart';
