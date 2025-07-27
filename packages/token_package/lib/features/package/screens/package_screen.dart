import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/lib.dart';
import '../../commons/enums/user_roles.dart';
import '../../commons/providers/user_state_provider.dart';
import '../../commons/widgets/lib.dart';
import '../models/lib.dart';
import '../utils/lib.dart';
import '../view_models/lib.dart';

class PackageScreen extends ConsumerWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tokenPackageViewModelProvider);
    final notifier = ref.read(tokenPackageViewModelProvider.notifier);
    final userProfile = ref.watch(userStateProvider);
    return CardFrame(
      child: state.when(
        error: (error, stackTrace) => const Text('error!'),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '토큰 패키지',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (userProfile.role == UserRole.admin.toString())
                  TextButton(
                    child: Text(
                      '패키지 등록하기 ${userProfile.role}',
                      style: const TextStyle(
                          fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final router = ref.read(goRouterProvider);
                      router.goNamed(TokenRouterPath.packageRegister.name);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (data.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ...data.activePackages.take(3).map(
                    (package) => ListTile(
                      title: Text(package.name),
                      subtitle: Text(
                          '${package.totalTokens} 토큰 - ${package.displayPrice}'),
                      trailing: package.bonusTokens != null &&
                              package.bonusTokens! > 0
                          ? Chip(label: Text('+${package.bonusTokens} 보너스'))
                          : null,
                      onTap: () {
                        notifier.selectPackage(package);
                        showTokenPurchaseDialog(context, ref);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
