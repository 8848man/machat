part of '../lib.dart';

// snackBarCaller의 데이터를 관리하는 StateProvider
final StateProvider<SnackBarManagerData> snackBarManagerProvider =
    StateProvider<SnackBarManagerData>((ref) {
  return SnackBarManagerData();
});
