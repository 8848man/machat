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

// Widget shrinkTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) {
//   return ScaleTransition(
//     scale: Tween<double>(
//       begin: 1,
//       end: 0.6, // 40%로 줄임
//     ).animate(CurvedAnimation(
//       parent: animation,
//       curve: Curves.easeInOutQuart,
//     )),
//     child: child,
//   );
// }

//route
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        /// splash
        GoRoute(
          path: RouterPath.splash.path,
          name: RouterPath.splash.name,
          // builder: (context, state) => const SplashPage(),
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashPage(),
            transitionsBuilder: fadeTransition,
          ),
        ),

        /// home
        GoRoute(
          path: RouterPath.home.path,
          name: RouterPath.home.name,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder: fadeTransition,
          ),
          routes: [
            /// chat create/modify
            GoRoute(
              path: RouterPath.chatCreate.path,
              name: RouterPath.chatCreate.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const ChatCreate(),
                transitionsBuilder: fadeTransition,
              ),
            ),

            /// chat list
            GoRoute(
              path: RouterPath.chatList.path,
              name: RouterPath.chatList.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const ChatList(),
                transitionsBuilder: fadeTransition,
              ),
            ),

            /// profile
            GoRoute(
              path: RouterPath.profile.path,
              name: RouterPath.profile.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const MyProfile(),
                transitionsBuilder: fadeTransition,
              ),
            ),

            /// add friend
            GoRoute(
              path: RouterPath.addFriend.path,
              name: RouterPath.addFriend.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const AddFriend(),
                transitionsBuilder: fadeTransition,
              ),
            ),
          ],
        ),

        /// chat
        GoRoute(
          path: RouterPath.chat.path,
          name: RouterPath.chat.name,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const ChatScreen(),
            transitionsBuilder: fadeTransition,
          ),
          routes: [
            GoRoute(
              path: RouterPath.chatImage.path,
              name: RouterPath.chatImage.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                transitionDuration: const Duration(milliseconds: 500),
                key: state.pageKey,
                child: const ExpandImage(),
                transitionsBuilder: slideTransition,
              ),
            ),
            GoRoute(
              path: RouterPath.chatProfile.path,
              name: RouterPath.chatProfile.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                transitionDuration: const Duration(milliseconds: 500),
                key: state.pageKey,
                child: const OtherProfile(),
                transitionsBuilder: slideTransition,
              ),
            ),
          ],
        ),

        /// login
        GoRoute(
          path: RouterPath.login.path,
          name: RouterPath.login.name,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: fadeTransition,
          ),
          routes: [
            GoRoute(
              path: RouterPath.register.path,
              name: RouterPath.register.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const RegisterPage(),
                transitionsBuilder: fadeTransition,
              ),
            ),
          ],
        ),

        // GoRoute(
        //   path: RouterPath.addFriend.path,
        //   name: RouterPath.addFriend.name,
        //   pageBuilder: (context, state) => CustomTransitionPage<void>(
        //     key: state.pageKey,
        //     child: const AddFriend(),
        //     transitionsBuilder: fadeTransition,
        //   ),
        // ),

        // GoRoute(
        //     path: RouterPath.app.path,
        //     name: RouterPath.app.name,
        //     pageBuilder: (context, state) => CustomTransitionPage<void>(
        //           key: state.pageKey,
        //           child: Frame(),
        //           transitionsBuilder: fadeTransition,
        //         ),
        //     routes: [
        //       // GoRoute(
        //       //   path: RouterPath.studemtManagement.path,
        //       //   name: RouterPath.studemtManagement.name,
        //       //   pageBuilder: (context, state) => CustomTransitionPage<void>(
        //       //     transitionDuration: const Duration(milliseconds: 500),
        //       //     key: state.pageKey,
        //       //     child:  ManagementStudent(),
        //       //     transitionsBuilder: slideTransition,
        //       //   ),
        //       // ),
        //     ]),
        // example
        // GoRoute(
        //   path: RouterPath.example.path,
        //   name: RouterPath.example.name,
        //   pageBuilder: (context, state) => CustomTransitionPage<void>(
        //     key: state.pageKey,
        //     child: const ExamplePage(),
        //     transitionsBuilder: fadeTransition,
        //   ),
        //   routes: [
        //     // example 하위라우팅
        //     // example/radio_button
        //     GoRoute(
        //       path: RouterPath.radioButton.path,
        //       name: RouterPath.radioButton.name,
        //       pageBuilder: (context, state) => CustomTransitionPage<void>(
        //         key: state.pageKey,
        //         child: const RadioButton(),
        //         transitionsBuilder: fadeTransition,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  },
);
