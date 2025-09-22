library mc_router;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/features/add_friends/lib.dart';
import 'package:machat/features/ai/features/ai_create/screens/ai_create_screen.dart';
import 'package:machat/features/ai/presentation/screens/ai_home_screen.dart';
import 'package:machat/features/chat/lib.dart';
import 'package:machat/features/chat_create/lib.dart';
import 'package:machat/features/chat/features/chat_expand_image/screens/expand_image.dart';
import 'package:machat/features/common/features/token/screens/token_screen.dart';
import 'package:machat/features/home/lib.dart';
import 'package:machat/features/home/presentation/widgets/earn_point_bundle.dart';
import 'package:machat/features/login/lib.dart';
import 'package:machat/features/open_chat_list/presentation/screens/chat_list.dart';
import 'package:machat/features/profile/presentation/screens/my_profile.dart';
import 'package:machat/features/profile/presentation/screens/other_profile.dart';
import 'package:machat/features/register/lib.dart';
import 'package:machat/features/splash/lib.dart';
import 'package:machat/features/study/features/voca/presentation/screens/english_voca.dart';
import 'package:machat/features/study/features/add_vocabulary/screens/add_vocabulary.dart';
import 'package:machat/features/study/features/voabulary_manage/screens/vocabulary_manage.dart';
import 'package:machat/features/study/features/voca/presentation/screens/add_voca.dart';
import 'package:machat/features/study/presentation/screens/study_subject_screen.dart';

part './router.dart';
part './router_path.dart';
