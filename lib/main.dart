import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/router/lib.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 앱 실행전 초기화
void init() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        'Error: ${details.exception}', // 오류 메시지 표시
        style: const TextStyle(color: Colors.red),
      ),
    );
  };

  //가로화면 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  // firebase 연동 코드 (필요시)
  // await HTTPConnector.init();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //전체화면 설정
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //전역 라우팅
    final goRoute = ref.watch(goRouterProvider);
    // final snackbarState = ref.watch(snackbarProvider);

    //(필요시) -> 토큰없으면 로그인 페이지로 보내기 추가 가능

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return ScreenUtilInit(
          designSize: Size(screenWidth, screenHeight),
          child: MaterialApp.router(
            // scaffoldMessengerKey: snackbarState.scaffoldMessengerKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(scaffoldBackgroundColor: MCColors.$color_grey_00),
            routerConfig: goRoute,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
