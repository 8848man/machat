import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/models/token_log_model.dart';
import 'package:machat/features/token/models/token_model.dart';
import 'package:machat/features/token/models/token_package_model.dart';
import 'package:machat/features/token/router/lib.dart';
import 'package:machat/features/token/view_models/token_package_view_model.dart';
import 'package:machat/features/token/view_models/token_view_model.dart';

class TokenPage extends ConsumerWidget {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('토큰 관리 예시'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // 토큰 정보 섹션
            _buildTokenInfoSection(),
            // const SizedBox(height: 20),

            // 일일 보상 섹션
            _buildDailyRewardSection(),
            // const SizedBox(height: 20),

            // // 토큰 사용 섹션
            _buildTokenUsageSection(),
            // const SizedBox(height: 20),

            // // 토큰 패키지 섹션
            _buildTokenPackagesSection(),
            // const SizedBox(height: 20),

            // 토큰 로그 섹션
            _buildTokenLogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenInfoSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(tokenViewModelProvider);
        return state.when(
          error: (error, stackTrace) => const Text('에러!'),
          loading: () => const CircularProgressIndicator(),
          data: (data) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '토큰 정보',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '현재 보유 토큰: ${data.userToken != null ? data.userToken!.currentTokens : '없음'}'),
                  Text(
                    '총 획득 토큰: ${data.userToken != null ? data.userToken!.totalEarnedTokens : '없음'}',
                  ),
                  Text(
                      '총 사용 토큰: ${data.userToken != null ? data.userToken!.totalSpentTokens : '없음'}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyRewardSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(tokenViewModelProvider);
        final notifier = ref.read(tokenViewModelProvider.notifier);
        return state.when(
          error: (error, stackTrace) => const Text("error!"),
          loading: () => const CircularProgressIndicator(),
          data: (data) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '일일 보상',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (data.userToken != null)
                    Text(
                        '보상 받을 수 있음: ${data.userToken!.canReceiveDailyReward() ? "예" : "아니오"}'),
                  const SizedBox(height: 8),
                  if (data.userToken != null)
                    ElevatedButton(
                      onPressed: data.userToken!.canReceiveDailyReward() &&
                              !data.isLoading
                          ? () async {
                              final success = await notifier.claimDailyReward();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('일일 보상을 받았습니다!')),
                                );
                              }
                            }
                          : null,
                      child: const Text('일일 보상 받기'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenUsageSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(tokenViewModelProvider);
        final notifier = ref.read(tokenViewModelProvider.notifier);
        return state.when(
          error: (error, stackTrace) => const Text("error!"),
          loading: () => const CircularProgressIndicator(),
          data: (data) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '토큰 사용',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: !data.isLoading
                              ? () async {
                                  final success = await notifier.spendTokens(
                                    5,
                                    description: '테스트 사용',
                                  );
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('토큰을 사용했습니다!')),
                                    );
                                  }
                                }
                              : null,
                          child: const Text('5 토큰 사용'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: !data.isLoading
                              ? () async {
                                  final success = await notifier.spendTokens(
                                    10,
                                    description: '고급 기능 사용',
                                  );
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('고급 기능을 사용했습니다!')),
                                    );
                                  }
                                }
                              : null,
                          child: const Text('10 토큰 사용'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenPackagesSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(tokenPackageViewModelProvider);
        final notifier = ref.read(tokenPackageViewModelProvider.notifier);

        return state.when(
          data: (data) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '토큰 패키지',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        child: const Text(
                          '패키지 등록하기',
                          style: TextStyle(
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
                                ? Chip(
                                    label: Text('+${package.bonusTokens} 보너스'))
                                : null,
                            onTap: () => notifier.selectPackage(package),
                          ),
                        ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => const Text('error!'),
          loading: () => const CircularProgressIndicator(),
        );
      },
    );
  }

  // Widget _buildTokenLogsSection() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       ref.watch();
  //       return Card(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 '토큰 사용 내역',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 8),
  //               if (tokenVM.tokenLogs.isEmpty)
  //                 const Text('사용 내역이 없습니다.')
  //               else
  //                 ...tokenVM.tokenLogs.take(5).map((log) => ListTile(
  //                       title: Text(log.displayDescription),
  //                       subtitle:
  //                           Text(log.createdAt.toString().substring(0, 16)),
  //                       trailing: Text(
  //                         log.displayAmount,
  //                         style: TextStyle(
  //                           color: log.amount > 0 ? Colors.green : Colors.red,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     )),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildTokenLogsSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(tokenViewModelProvider);
        return state.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => const Text("error1!"),
          data: (data) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '토큰 사용 내역',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (data.tokenLogs.isEmpty)
                    const Text('사용 내역이 없습니다.')
                  else
                    ...data.tokenLogs.take(5).map(
                          (log) => ListTile(
                            title: Text(log.displayDescription),
                            subtitle:
                                Text(log.createdAt.toString().substring(0, 16)),
                            trailing: Text(
                              log.displayAmount,
                              style: TextStyle(
                                color:
                                    log.amount > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 토큰 기능 초기화 예시
class TokenFeatureInitializer {
  static void initialize() {
    // 필요한 경우 여기서 토큰 관련 전역 설정을 초기화할 수 있습니다.
    // 예: 기본 토큰 패키지 생성, 설정 로드 등
  }
}
