import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';

final userProfileProvider =
    StateProvider<UserData>((ref) => const UserData(name: 'guest'));
