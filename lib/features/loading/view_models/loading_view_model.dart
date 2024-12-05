import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = NotifierProvider<LoadingViewModel, bool>(() {
  return LoadingViewModel();
});

class LoadingViewModel extends Notifier<bool> {
  @override
  bool build() => false; // 초기 상태 설정

  void showLoading() => state = true;
  void hideLoading() => state = false;
}
