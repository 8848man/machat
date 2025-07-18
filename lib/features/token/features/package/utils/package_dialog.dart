import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/package/providers/lib.dart';
import 'package:machat/features/token/features/token/lib.dart';

void showTokenPurchaseDialog(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Consumer(builder: (context, ref, child) {
        final package = ref.watch(selectedPackageProvider);
        // TODO: 토큰 구매 로직을 패키지 기능 권한으로 옮기기
        final notifier = ref.read(tokenViewModelProvider.notifier);
        if (package == null) {
          return const Center(
            child: Text("선택된 패키지가 없습니다!"),
          );
        }
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                        height: double.infinity, child: Text('패키지 이미지')),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('패키지 이름 : ${package.name}'),
                                  Text('패키지 설명 : ${package.description}'),
                                  Text('토큰 갯수 : ${package.tokenAmount}'),
                                  Text('패키지 원가 : ${package.price}'),
                                  // Text('패키지 할인가 : ${package.}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  notifier.purchaseTokens(
                                      package.tokenAmount, package.price);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('구매하기')),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('뒤로가기')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}
