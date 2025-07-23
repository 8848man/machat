library mc_login;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/providers/loading_state_provider.dart';
import 'package:machat/features/login/models/login_model.dart';
import 'package:machat/features/login/view_models/login_view_model.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';

part './screens/login_page.dart';
part './widgets/login_bundle.dart';
part './widgets/bundle_header.dart';
part './widgets/bundle_body.dart';
part './widgets/bundle_footer.dart';
