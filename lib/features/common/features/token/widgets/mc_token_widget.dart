import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/router/lib.dart';
import 'package:machat_token_service/features/token/lib.dart';

class MCToken extends ConsumerWidget {
  const MCToken({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(goRouterProvider);
    final state = ref.watch(tokenViewModelProvider);

    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (data) {
        return _buildTokenWidget(context, router, data);
      },
    );
  }

  Widget _buildTokenWidget(
      BuildContext context, GoRouter router, TokenStateModel data) {
    if (data.userToken == null) {
      return Container();
    }
    return McAppear(
      isSlideUp: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () => router.goNamed(RouterPath.token.name),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 60, maxHeight: 20),
            decoration: BoxDecoration(
              border: Border.all(color: MCColors.$color_blue_40),
              borderRadius: BorderRadius.circular(8),
              color: MCColors.$color_grey_20,
            ),
            child: Center(
              child: Text('${data.userToken!.currentTokens}P'),
            ),
          ),
        ),
      ),
    );
  }
}
