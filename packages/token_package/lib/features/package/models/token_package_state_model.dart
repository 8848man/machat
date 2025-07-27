import 'package:freezed_annotation/freezed_annotation.dart';
import '../lib.dart';

part 'token_package_state_model.freezed.dart';

@freezed
class TokenPackageStateModel with _$TokenPackageStateModel {
  const factory TokenPackageStateModel({
    @Default([]) List<TokenPackageModel> activePackages,
    @Default([]) List<TokenPackageModel> popularPackages,
    @Default([]) List<TokenPackageModel> filteredPackages,
    // TokenPackageModel? selectedPackage,
    @Default(false) bool isLoading,
    String? error,
  }) = _TokenPackageStateModel;
}
