import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/config/firebase_config.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/token/router/lib.dart';

void main() async {
  await init();

  runApp(
    const ProviderScope(
      child: TokenMain(),
    ),
  );
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      print('firebase init web');
      // 웹 플랫폼일 경우 FirebaseOptions 사용
      await Firebase.initializeApp(options: firebaseOptions);
    } else {
      print('firebase init mobile');
      // 모바일 플랫폼일 경우 기본 Firebase 설정
      await Firebase.initializeApp();
    }
  } catch (e, stack) {
    print("Firebase 초기화 실패: $e");
    print(stack);
  }
}

class TokenMain extends ConsumerWidget {
  const TokenMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRoute = ref.watch(goRouterProvider);
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(scaffoldBackgroundColor: MCColors.$color_grey_00),
      routerConfig: goRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
