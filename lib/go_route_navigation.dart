// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/view/auth/create_account_vc.dart';
import 'package:focus_tube_flutter/view/auth/forgot_password_vc.dart';
import 'package:focus_tube_flutter/view/auth/login_vc.dart';
import 'package:focus_tube_flutter/view/auth/reset_password_vc.dart';
import 'package:focus_tube_flutter/view/auth/verification_vc.dart';
import 'package:go_router/go_router.dart';

import 'package:focus_tube_flutter/view/onboarding_vc.dart';

import 'view/content_vc.dart';

//MARK: SCREEN ROUTES MODELS

//Onboarding
AppNavigationModel onboarding = AppNavigationModel(
  label: "Onboarding",
  path: OnboardingVC.id,
  child: (BuildContext context, GoRouterState state) => const OnboardingVC(),
);

//Create Account
AppNavigationModel signUp = AppNavigationModel(
  label: "Sign Up",
  path: CreateAccountVC.id,
  child: (BuildContext context, GoRouterState state) => const CreateAccountVC(),
);

//Login
AppNavigationModel signIn = AppNavigationModel(
  label: "Sign In",
  path: LoginVC.id,
  child: (BuildContext context, GoRouterState state) => const LoginVC(),
);

//Forgot Password
AppNavigationModel forgotPassword = AppNavigationModel(
  label: "Forgot Password",
  path: ForgotPasswordVC.id,
  child: (BuildContext context, GoRouterState state) =>
      const ForgotPasswordVC(),
);

//Email Verification
AppNavigationModel emailVerification = AppNavigationModel(
  label: "Email Verification",
  path: VerificationVC.id,
  child: (BuildContext context, GoRouterState state) => const VerificationVC(),
);
AppNavigationModel forgotPasswordVerification = AppNavigationModel(
  label: "Forgot Password Verification",
  path: VerificationVC.forgotPasswordId,
  child: (BuildContext context, GoRouterState state) =>
      const VerificationVC(isFromForgotPassword: true),
);
//Reset Password
AppNavigationModel resetPassword = AppNavigationModel(
  label: "Reset Password",
  path: ResetPasswordVC.id,
  child: (BuildContext context, GoRouterState state) => const ResetPasswordVC(),
);
var content = AppNavigationModel(
  label: "Content",
  path: "${ContentVC.screenId}/:id",
  child: (context, state) {
    String id = state.pathParameters['id']!;

    return ContentVC(type: id);
  },
);

//MARK: ROUTER MODEL
class AppNavigationModel {
  String label;
  String path;
  String? name;
  IconData? icon;
  Widget Function(BuildContext context, GoRouterState state) child;

  AppNavigationModel({
    this.name,
    required this.label,
    required this.path,
    this.icon,
    required this.child,
  });

  String route({dynamic id}) {
    if (id != null && path.contains('/:id')) {
      return path.replaceAll(':id', id.toString());
    }
    return path;
  }

  static untilFirst(BuildContext context) async {
    // Get the current navigation history stack (list of matched route locations)
    var locationHistory = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .map((e) => e.matchedLocation)
        .toList();
    // Proceed only if there's any history

    for (var i = 1; i < locationHistory.length; i++) {
      // Pop each page until the first one
      if (context.canPop()) {
        context.pop();
      }
    }
  }
}

class NoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Constructor for a page with no transition functionality.
  const NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
         transitionsBuilder: _transitionsBuilder,
         transitionDuration: Duration.zero,
         reverseTransitionDuration: Duration.zero,
       );

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

extension AppNavigator on BuildContext {
  pushPage(String location, {Object? extra}) async {
    if (kIsWeb) {
      go(location, extra: extra);
    } else {
      return await push(location, extra: extra);
    }
  }
}

extension AppRouteModelExtension on AppNavigationModel {
  GoRoute toGoRoute({List<RouteBase> routes = const <RouteBase>[]}) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: child(context, state)),
    );
  }

  go(BuildContext context, {dynamic id, Object? extra}) async {
    return await context.push(route(id: id), extra: extra);
  }

  off(BuildContext context, {dynamic id, Object? extra}) {
    context.go(route(id: id), extra: extra);
  }

  replace(BuildContext context, {dynamic id, Object? extra}) async {
    if (context.canPop() && !kIsWeb) {
      context.pop();
    }
    return await go(context, id: id, extra: extra);
  }

  until(BuildContext context, {dynamic id, Object? extra}) async {
    // Get the current navigation history stack (list of matched route locations)
    var locationHistory = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .map((e) => e.matchedLocation)
        .toList();
    // Proceed only if there's any history
    if (locationHistory.isNotEmpty) {
      // Try to find the index of the target path in the history stack
      var index = locationHistory.indexWhere((e) => e.contains(path));
      if (index != -1) {
        // If path is found, calculate how many pages to pop to reach it
        for (var i = 0; i < (locationHistory.length - (index + 1)); i++) {
          if (context.canPop()) {
            context.pop(); // Pop one page at a time
          }
        }
      } else {
        if (context.canPop()) {
          context.pop(); // Pop one page at a time
        }
        // If the path isn't in the current stack, navigate to it directly
        return await go(context, id: id, extra: extra);
      }
    } else {
      // Proceed only if there's not any history
      return await go(context, id: id, extra: extra);
    }
  }
}

//MARK: ROUTE
GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
GoRouter router = GoRouter(
  navigatorKey: navigationKey,
  initialLocation: onboarding.path,
  routes: [
    ...[
      onboarding,
      signUp,
      signIn,
      forgotPassword,
      emailVerification,
      resetPassword,
      content,
    ].map((e) => e.toGoRoute()),
  ],
);
