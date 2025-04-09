import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';

StateProvider<List<UserData>> friendListProvider = StateProvider((ref) => []);
