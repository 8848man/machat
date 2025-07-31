library mc_router;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/features/add_friends/lib.dart';
import 'package:machat/features/chat/lib.dart';
import 'package:machat/features/chat_create/lib.dart';
import 'package:machat/features/chat_list/lib.dart';
import 'package:machat/features/chat_expand_image/screens/expand_image.dart';
import 'package:machat/features/common/features/token/screens/token_screen.dart';
import 'package:machat/features/home/lib.dart';
import 'package:machat/features/home/widgets/earn_point_bundle.dart';
import 'package:machat/features/login/lib.dart';
import 'package:machat/features/profile/screens/my_profile.dart';
import 'package:machat/features/profile/screens/other_profile.dart';
import 'package:machat/features/register/lib.dart';
import 'package:machat/features/splash/lib.dart';
import 'package:machat/features/study/features/english/screens/study_english.dart';
import 'package:machat/features/study/features/subject_manage/features/add_voca_list/screens/add_vocabulary.dart';
import 'package:machat/features/study/features/subject_manage/screens/subject_manage.dart';
import 'package:machat/features/study/screens/study_subject_screen.dart';

part './router.dart';
part './router_path.dart';
