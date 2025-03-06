import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/home/views/home_screen.dart';
import 'package:mood_tracker/main_navigation.dart';
import 'package:mood_tracker/utils.dart';
import 'features/authentication/repos/authentication_repo.dart';
import 'features/authentication/views/login_screen.dart';
import 'features/authentication/views/sign_up_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != LoginScreen.routeURL) {
          return LoginScreen.routeURL;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        pageBuilder: (context, state) => Utils.animationPage(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        pageBuilder: (context, state) => Utils.animationPage(
          state,
          const SignUpScreen(),
        ),
      ),
      GoRoute(
        name: HomeScreen.routeName,
        path: '/',
        pageBuilder: (context, state) =>
            Utils.animationPage(state, const MainNavigation(tab: 'home')),
      ),
      GoRoute(
        path: "/:tab(home|write)",
        name: MainNavigation.routeName,
        pageBuilder: (context, state) {
          final tab = state.pathParameters["tab"]!;

          return Utils.animationPage(
            state,
            MainNavigation(tab: tab),
          );
        },
      ),
    ],
  );
});
