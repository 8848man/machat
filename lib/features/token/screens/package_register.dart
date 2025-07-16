import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/design_system/lib.dart';

class PackageRegister extends ConsumerWidget {
  const PackageRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('토큰 관리 예시'),
      ),
      body: getRegisterBundle(context),
    );
  }

  Widget getRegisterBundle(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '토큰 패키지',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MCTextInput(
              labelText: '패키지 이름',
              controller: TextEditingController(),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            MCTextInput(
              labelText: '토큰 수',
              controller: TextEditingController(),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            MCTextInput(
              labelText: '원래 가격',
              controller: TextEditingController(),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            MCTextInput(
              labelText: '할인 가격',
              controller: TextEditingController(),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Confirm'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
