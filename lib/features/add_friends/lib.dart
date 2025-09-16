import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/add_friends/data/models/add_friend.dart';
import 'package:machat/features/add_friends/presentation/view_models/add_friend_view_model.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/models/users/user_data.dart';
import 'package:machat/features/common/widgets/mc_pop_scope.dart';
import 'package:machat/features/home/lib.dart';
import 'package:machat/router/lib.dart';

part 'presentation/screens/add_friend.dart';
part 'presentation/widgets/searched_friends.dart';
part 'presentation/widgets/search_friend.dart';
part 'presentation/enums/friend_search_by.dart';
