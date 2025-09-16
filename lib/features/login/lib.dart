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
import 'package:machat/features/login/presentation/view_models/login_view_model.dart';
import 'package:machat/core/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';

part 'presentation/screens/login_page.dart';
part 'presentation/widgets/login_bundle.dart';
part 'presentation/widgets/bundle_header.dart';
part 'presentation/widgets/bundle_body.dart';
part 'presentation/widgets/bundle_footer.dart';
