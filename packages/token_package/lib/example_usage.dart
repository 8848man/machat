// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'lib.dart';

// /// 토큰 기능 사용 예시
// /// 이 파일은 토큰 기능을 어떻게 사용하는지 보여주는 예시입니다.

// class TokenUsageExample extends StatelessWidget {
//   const TokenUsageExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ProviderScope(
//       child: TokenExampleScreen(),
//     );
//   }
// }

// class TokenExampleScreen extends StatefulWidget {
//   const TokenExampleScreen({super.key});

//   @override
//   State<TokenExampleScreen> createState() => _TokenExampleScreenState();
// }

// class _TokenExampleScreenState extends State<TokenExampleScreen> {
//   final String userId = 'example_user_id'; // 실제 사용자 ID로 변경

//   @override
//   void initState() {
//     super.initState();
//     // 화면 로드 시 데이터 초기화
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<TokenViewModel>().loadUserToken(userId);
//       context.read<TokenViewModel>().loadUserTokenLogs(userId);
//       context.read<TokenPackageViewModel>().loadActivePackages();
//       context.read<TokenPackageViewModel>().loadPopularPackages();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('토큰 관리 예시'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 토큰 정보 섹션
//             _buildTokenInfoSection(),
//             const SizedBox(height: 20),

//             // 일일 보상 섹션
//             _buildDailyRewardSection(),
//             const SizedBox(height: 20),

//             // 토큰 사용 섹션
//             _buildTokenUsageSection(),
//             const SizedBox(height: 20),

//             // 토큰 패키지 섹션
//             _buildTokenPackagesSection(),
//             const SizedBox(height: 20),

//             // 토큰 로그 섹션
//             _buildTokenLogsSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTokenInfoSection() {
//     return Consumer<TokenViewModel>(
//       builder: (context, tokenVM, child) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '토큰 정보',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text('현재 보유 토큰: ${tokenVM.currentTokens}'),
//                 Text('총 획득 토큰: ${tokenVM.totalEarnedTokens}'),
//                 Text('총 사용 토큰: ${tokenVM.totalSpentTokens}'),
//                 if (tokenVM.isLoading)
//                   const Padding(
//                     padding: EdgeInsets.only(top: 8.0),
//                     child: CircularProgressIndicator(),
//                   ),
//                 if (tokenVM.error != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       '오류: ${tokenVM.error}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDailyRewardSection() {
//     return Consumer<TokenViewModel>(
//       builder: (context, tokenVM, child) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '일일 보상',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                     '보상 받을 수 있음: ${tokenVM.canReceiveDailyReward ? "예" : "아니오"}'),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: tokenVM.canReceiveDailyReward && !tokenVM.isLoading
//                       ? () async {
//                           final success =
//                               await tokenVM.claimDailyReward(userId);
//                           if (success) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('일일 보상을 받았습니다!')),
//                             );
//                           }
//                         }
//                       : null,
//                   child: const Text('일일 보상 받기'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTokenUsageSection() {
//     return Consumer<TokenViewModel>(
//       builder: (context, tokenVM, child) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '토큰 사용',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: !tokenVM.isLoading
//                             ? () async {
//                                 final success = await tokenVM.spendTokens(
//                                   userId,
//                                   5,
//                                   description: '테스트 사용',
//                                 );
//                                 if (success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text('토큰을 사용했습니다!')),
//                                   );
//                                 }
//                               }
//                             : null,
//                         child: const Text('5 토큰 사용'),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: !tokenVM.isLoading
//                             ? () async {
//                                 final success = await tokenVM.spendTokens(
//                                   userId,
//                                   10,
//                                   description: '고급 기능 사용',
//                                 );
//                                 if (success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text('고급 기능을 사용했습니다!')),
//                                   );
//                                 }
//                               }
//                             : null,
//                         child: const Text('10 토큰 사용'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTokenPackagesSection() {
//     return Consumer<TokenPackageViewModel>(
//       builder: (context, ref, child) {
//         final notifier = ref.read(tokenPackageViewmodelPRovider);
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '토큰 패키지',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 if (ref.isLoading)
//                   const Center(child: CircularProgressIndicator())
//                 else
//                   ...ref.activePackages.take(3).map((package) => ListTile(
//                         title: Text(package.name),
//                         subtitle: Text(
//                             '${package.totalTokens} 토큰 - ${package.displayPrice}'),
//                         trailing: package.bonusTokens != null &&
//                                 package.bonusTokens! > 0
//                             ? Chip(label: Text('+${package.bonusTokens} 보너스'))
//                             : null,
//                         onTap: () => ref.selectPackage(package),
//                       )),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTokenLogsSection() {
//     return Consumer<TokenViewModel>(
//       builder: (context, tokenVM, child) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '토큰 사용 내역',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 if (tokenVM.tokenLogs.isEmpty)
//                   const Text('사용 내역이 없습니다.')
//                 else
//                   ...tokenVM.tokenLogs.take(5).map((log) => ListTile(
//                         title: Text(log.displayDescription),
//                         subtitle:
//                             Text(log.createdAt.toString().substring(0, 16)),
//                         trailing: Text(
//                           log.displayAmount,
//                           style: TextStyle(
//                             color: log.amount > 0 ? Colors.green : Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// /// 토큰 기능 초기화 예시
// class TokenFeatureInitializer {
//   static void initialize() {
//     // 필요한 경우 여기서 토큰 관련 전역 설정을 초기화할 수 있습니다.
//     // 예: 기본 토큰 패키지 생성, 설정 로드 등
//   }
// }
