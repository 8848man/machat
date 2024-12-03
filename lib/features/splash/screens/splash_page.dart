part of '../lib.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.read(goRouterProvider);

    //TODO 로그인 토큰 여부로 화면 분기처리

    Future.delayed(const Duration(seconds: 2)).then((_) {
      route.go(RouterPath.login.path);
      // MaterialPageRoute(builder: ((context) => LoginPage()));
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        // child: SvgPicture.asset(
        //   'lib/assets/images/img_splash_page.svg',
        //   height: FigmaPixel().getHeightPixel(height: 800),
        //   width: ScreenUtil().screenWidth * 1,
        // ),
        child: Container(
          width: 100,
          height: 100,
          color: MCColors.$color_blue_60,
        ),
      ),
    );
  }
}
