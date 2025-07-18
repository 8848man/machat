import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/commons/widgets/lib.dart';
import 'package:machat/features/token/features/package/lib.dart';
import 'package:machat/features/token/features/package/utils/lib.dart';
import 'package:machat/features/token/router/lib.dart';

class PackageScreen extends ConsumerWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tokenPackageViewModelProvider);
    final notifier = ref.read(tokenPackageViewModelProvider.notifier);
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
                TextButton(
                  child: const Text(
                    '패키지 등록하기',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
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
