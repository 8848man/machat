library mc_layout;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/features/common/utils/user_checker.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/drawer/lib.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/router/lib.dart';

part './default_layout.dart';
part './mobile_scaffold.dart';
part './web_scaffold.dart';
part './get_actions.dart';
