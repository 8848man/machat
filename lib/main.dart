import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machat/config/firebase_config.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/router/lib.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:machat_token_service/firebase_instances/firebase_instance_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();
  setupErrorWidget();
  lockOrientation();

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  runApp(
    ProviderScope(
      overrides: appOverrides(firestore, firebaseAuth),
      child: const MyApp(),
    ),
  );
}

/// Firebase 초기화
Future<void> initFirebase() async {
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(options: firebaseOptions);
    } else {
      await Firebase.initializeApp();
    }
  } catch (e, stack) {
    print("Firebase 초기화 실패: $e");
    print(stack);
  }
}

/// 글로벌 에러 위젯 설정
void setupErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        'Error: ${details.exception}',
        style: const TextStyle(color: Colors.red),
      ),
    );
  };
}

/// 화면 방향 고정
void lockOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// Provider overrides
List<Override> appOverrides(FirebaseFirestore firestore, FirebaseAuth auth) => [
      firebaseFirestoreProvider.overrideWithValue(firestore),
      firebaseAuthProvider.overrideWithValue(auth),
    ];

/// App 구성
class AppConfigurator extends StatelessWidget {
  final Widget child;
  const AppConfigurator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 전체 화면 모드 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // ScreenUtilInit으로 화면 크기 기반 scaling 적용
    return ScreenUtilInit(
      designSize: const Size(360, 690), // 기본 디자인 기준
      minTextAdapt: true,
      builder: (context, childWidget) => childWidget!,
      child: child,
    );
  }
}

/// MyApp (UI 트리만 담당)
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return AppConfigurator(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: MCColors.$color_grey_00),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: goRouter,
      ),
    );
  }
}
