import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/package/models/token_package_model.dart';

final StateProvider<TokenPackageModel?> selectedPackageProvider =
    StateProvider<TokenPackageModel?>((ref) {
  return null;
});
