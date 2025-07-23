import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/add_friends/models/add_friend.dart';
import 'package:machat/features/add_friends/view_models/add_friend_view_model.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/widgets/mc_pop_scope.dart';
import 'package:machat/features/home/lib.dart';
import 'package:machat/router/lib.dart';

part './screens/add_friend.dart';
part './widgets/searched_friends.dart';
part './widgets/search_friend.dart';
part './enums/friend_search_by.dart';
