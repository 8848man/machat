import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenPage extends ConsumerWidget {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }

  // Widget _buildTokenLogsSection() {
  //   return Consumer<TokenViewModel>(
  //     builder: (context, tokenVM, child) {
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
}
