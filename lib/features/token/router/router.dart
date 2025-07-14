part of './lib.dart';

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
            child: const TokenLoginPage(),
            transitionsBuilder: fadeTransition,
          ),
        ),
      ],
    );
  },
);
