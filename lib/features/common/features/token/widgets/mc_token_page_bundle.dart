import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat_token_service/features/commons/widgets/lib.dart';
import 'package:machat_token_service/features/package/screens/package_screen.dart';
import 'package:machat_token_service/features/token/models/lib.dart';
import 'package:machat_token_service/features/token/view_models/lib.dart';

class McTokenPageBundle extends ConsumerWidget {
  const McTokenPageBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 토큰'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(_buildSections().length, (index) {
              return McAppear(
                  delayMs: index * 400, child: _buildSections()[index]);
            })
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections() {
    return [
      _buildTokenInfoSection(),
      _buildDailyRewardSection(),
      // _buildTokenUsageSection(),
      const PackageScreen(),
      _buildTokenLogsSection(),
    ];
  }

  Widget _buildTokenInfoSection() {
    return CardFrame(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(tokenViewModelProvider);
          return state.when(
            error: (error, stackTrace) => const Text('에러!'),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (data) => Column(
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
          );
        },
      ),
    );
  }

  Widget _buildDailyRewardSection() {
    return CardFrame(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(tokenViewModelProvider);
          final notifier = ref.read(tokenViewModelProvider.notifier);
          return state.when(
            error: (error, stackTrace) => const Text("error!"),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '일일 보상',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (data.userToken != null)
                  Text(data.userToken!.canReceiveDailyReward()
                      ? "일일 보상을 받을 수 있어요"
                      : "이미 일일 보상을 받았어요"),
                const SizedBox(height: 8),
                if (data.userToken != null)
                  ElevatedButton(
                    onPressed: data.userToken!.canReceiveDailyReward() &&
                            !data.isLoading
                        ? () async {
                            final success = await notifier.claimDailyReward();
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('일일 보상을 받았습니다!')),
                              );
                            }
                          }
                        : null,
                    child: const Text('일일 보상 받기'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTokenUsageSection() {
    return CardFrame(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(tokenViewModelProvider);
          final notifier = ref.read(tokenViewModelProvider.notifier);
          return state.when(
            error: (error, stackTrace) => const Text("error!"),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (data) => Column(
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
          );
        },
      ),
    );
  }

  Widget _buildTokenLogsSection() {
    return CardFrame(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(tokenViewModelProvider);
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => const Text("error1!"),
            data: (data) => Column(
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
                          title:
                              Text(log.description ?? log.displayDescription),
                          subtitle:
                              Text(log.createdAt.toString().substring(0, 16)),
                          trailing: Text(
                            log.displayAmount,
                            style: TextStyle(
                              color: log.amount > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
