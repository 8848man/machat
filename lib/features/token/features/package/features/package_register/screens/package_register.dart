import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/token/features/commons/enums/user_roles.dart';
import 'package:machat/features/token/features/commons/providers/user_state_provider.dart';
import 'package:machat/features/token/features/commons/snack_bar_manager/lib.dart';
import 'package:machat/features/token/router/lib.dart';
import 'package:machat/features/token/features/package/features/package_register/view_models/package_register_view_model.dart';

class PackageRegister extends ConsumerStatefulWidget {
  const PackageRegister({super.key});

  @override
  ConsumerState<PackageRegister> createState() => _PackageRegisterState();
}

class _PackageRegisterState extends ConsumerState<PackageRegister> {
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  late final TextEditingController originPriceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController descriptionController;
  late final PackageRegisterViewModel notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(packageRegisterViewModelProvider.notifier);
    nameController = TextEditingController();
    amountController = TextEditingController();
    originPriceController = TextEditingController();
    discountPriceController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userStateProvider);

    if (userProfile.role != UserRole.admin.toString()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final router = ref.read(goRouterProvider);
        SnackBarCaller().callSnackBar(ref, '관리자만 접근할 수 있습니다.');
        router.pushReplacementNamed(TokenRouterPath.token.name);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('토큰 관리 예시'),
      ),
      body: getRegisterBundle(),
    );
  }

  Widget getRegisterBundle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(),
            const SizedBox(height: 16),
            buildPackageNameInput(),
            const SizedBox(height: 16),
            buildTokenAmountInput(),
            const SizedBox(height: 16),
            buildOriginPriceInput(),
            const SizedBox(height: 16),
            buildDiscountedPriceInput(),
            const SizedBox(height: 16),
            buildDescriptionInput(),
            const SizedBox(height: 16),
            buildButtonBundle(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return const Text(
      '토큰 패키지',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget buildPackageNameInput() {
    return MCTextInput(
      labelText: '패키지 이름',
      controller: nameController,
      backgroundColor: Colors.white,
    );
  }

  Widget buildTokenAmountInput() {
    return MCTextInput(
      labelText: '토큰 수',
      controller: amountController,
      backgroundColor: Colors.white,
    );
  }

  Widget buildOriginPriceInput() {
    return MCTextInput(
      labelText: '원래 가격',
      controller: originPriceController,
      backgroundColor: Colors.white,
    );
  }

  Widget buildDiscountedPriceInput() {
    return MCTextInput(
      labelText: '할인 가격',
      controller: discountPriceController,
      backgroundColor: Colors.white,
    );
  }

  Widget buildDescriptionInput() {
    return MCTextInput(
      labelText: '설명',
      controller: descriptionController,
      backgroundColor: Colors.white,
    );
  }

  Widget buildButtonBundle() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              notifier.registPackage(
                id: '',
                name: nameController.text,
                description: descriptionController.text,
                tokenAmount: int.parse(amountController.text),
                price: double.parse(originPriceController.text),
              );
              final router = ref.read(goRouterProvider);
              router.pushReplacementNamed(TokenRouterPath.token.name);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Confirm'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final router = ref.read(goRouterProvider);
              router.pushReplacementNamed(TokenRouterPath.token.name);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }
}
