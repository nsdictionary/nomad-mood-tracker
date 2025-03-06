import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Utils {
  static CustomTransitionPage animationPage(
    GoRouterState state,
    Widget targetScreen, {
    bool fullScreenDialog = false,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: targetScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(
            begin: fullScreenDialog
                ? const Offset(0.0, 1.0)
                : const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.ease))),
          child: child,
        );
      },
    );
  }

  static void animationRoute(
    BuildContext? context,
    Widget targetScreen, {
    bool removeUntil = false,
    bool fullScreenDialog = false,
  }) {
    var pageRouteBuilder = PageRouteBuilder(
      fullscreenDialog: fullScreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin =
            fullScreenDialog ? const Offset(0.0, 1.0) : const Offset(1.0, 0.0);
        final tween = Tween(
          begin: begin,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    );

    if (removeUntil) {
      Navigator.of(context!).pushAndRemoveUntil(
        pageRouteBuilder,
        (route) => false, // route에 따라서 선택적으로 유지할지 지울지 선택 가능 현재는 모두 삭제 처리
      );
    } else {
      Navigator.of(context!).push(pageRouteBuilder);
    }
  }
}

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}
