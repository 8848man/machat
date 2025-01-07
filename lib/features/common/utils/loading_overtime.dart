import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/utils/completer.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';

Widget loadingOvertime(WidgetRef ref) {
  final completer = ref.read(cancelCompleterProvider);

  Future.delayed(const Duration(seconds: 3), () {
    if (!completer.isCompleted) {
      completer.complete();
      ref.read(goRouterProvider).goNamed(RouterPath.home.name);
      showSnackBar(ref, '네트워크 연결이 불안정합니다. 다시 시도해주세요.');
    }
  });

  return const Center(
    child: CircularProgressIndicator(),
  );
}
