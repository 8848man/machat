import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';

void routerSnackbar(Ref ref, RouterPath path, String? message) {
  ref.read(goRouterProvider).goNamed(path.name);
  if (message == null) {
    return;
  }
  Future.delayed(const Duration(seconds: 1), () {
    showSnackBar(ref, message);
  });
}
