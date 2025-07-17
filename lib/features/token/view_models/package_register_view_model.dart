import 'package:machat/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/models/token_package_model.dart';
import 'package:machat/features/token/repositories/token_register_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_register_view_model.g.dart';

@riverpod
class PackageRegisterViewModel extends _$PackageRegisterViewModel {
  late final TokenPackageRegisterService _repository;
  @override
  void build() {
    _repository = ref.read(tokenPackageRegisterProvider);
  }

  Future<void> registPackage({
    required String id,
    required String name,
    required String description,
    required int tokenAmount,
    required double price,
  }) async {
    final TokenPackageModel data = TokenPackageModel(
      id: id,
      name: name,
      description: description,
      tokenAmount: tokenAmount,
      price: price,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.registPackage(data);
  }

  Future<TokenPackageModel> fetchPackageById(String id) async {
    final data = await _repository.fetchPackageById(id);
    return data;
  }

  Future<void> updatePacakge() async {}

  Future<void> deletePackage(String id) async {}
}
