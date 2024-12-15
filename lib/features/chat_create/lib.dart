library mc_chat_create;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat_create/models/chat_create_model.dart';
import 'package:machat/features/chat_create/view_models/chat_create_view_model.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/layouts/lib.dart';

part './repository/chat_create_repository.dart';
part './screens/chat_create.dart';
part './widgets/body.dart';
part './widgets/footer.dart';
part './widgets/header.dart';
