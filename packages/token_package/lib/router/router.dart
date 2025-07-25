part of 'lib.dart';

//화면전환
Widget fadeTransition(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) =>
    FadeTransition(opacity: animation, child: child);

Widget slideTransition(context, animation, secondaryAnimation, child) =>
    SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutQuart)),
      ),
      child: child,
    );

//route
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        /// splash
        GoRoute(
          path: TokenRouterPath.root.path,
          name: TokenRouterPath.root.name,
          // builder: (context, state) => const SplashPage(),
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const TokenSplash(),
            transitionsBuilder: fadeTransition,
          ),
        ),

        GoRoute(
          path: TokenRouterPath.login.path,
          name: TokenRouterPath.login.name,
          // builder: (context, state) => const SplashPage(),
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const TokenLoginPage(),
            transitionsBuilder: fadeTransition,
          ),
        ),

        GoRoute(
          path: TokenRouterPath.token.path,
          name: TokenRouterPath.token.name,
          // builder: (context, state) => const SplashPage(),
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const TokenPage(),
            transitionsBuilder: fadeTransition,
          ),
        ),

        GoRoute(
          path: TokenRouterPath.packageRegister.path,
          name: TokenRouterPath.packageRegister.name,
          // builder: (context, state) => const SplashPage(),
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const PackageRegister(),
            transitionsBuilder: fadeTransition,
          ),
        ),
      ],
    );
  },
);
