import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/service/encrypt_service.dart';
import 'package:focus_tube_flutter/view/auth/change_password_vc.dart';
import 'package:focus_tube_flutter/view/channels/add_channels_vc.dart';
import 'package:focus_tube_flutter/view/auth/choose_your_interest_vc.dart';
import 'package:focus_tube_flutter/view/auth/daily_limit_vc.dart';
import 'package:focus_tube_flutter/view/channels/channel_detail_vc.dart';
import 'package:focus_tube_flutter/view/goals/daily_goal_vc.dart';
import 'package:focus_tube_flutter/view/goals/set_daily_goal_vc.dart';
import 'package:focus_tube_flutter/view/home_root.dart';
import 'package:focus_tube_flutter/view/channels/my_channels_vc.dart';
import 'package:focus_tube_flutter/view/notes/note_detail_vc.dart';
import 'package:focus_tube_flutter/view/notes/note_list_vc.dart';
import 'package:focus_tube_flutter/view/playlists/playlist_detail_vc.dart';
import 'package:focus_tube_flutter/view/profile_vc.dart';
import 'package:focus_tube_flutter/view/subjects/select_subject_vc.dart';
import 'package:focus_tube_flutter/view/subjects/subject_detail_vc.dart';
import 'package:focus_tube_flutter/view/subjects/subject_vc.dart';
import 'package:focus_tube_flutter/view/videos/video_detail_vc.dart';
import 'package:focus_tube_flutter/view/videos/video_list_vc.dart';
import 'package:go_router/go_router.dart';

import 'package:focus_tube_flutter/view/onboarding_vc.dart';
import 'package:focus_tube_flutter/view/auth/create_account_vc.dart';
import 'package:focus_tube_flutter/view/auth/forgot_password_vc.dart';
import 'package:focus_tube_flutter/view/auth/login_vc.dart';
import 'package:focus_tube_flutter/view/auth/reset_password_vc.dart';
import 'package:focus_tube_flutter/view/auth/verification_vc.dart';
import 'package:focus_tube_flutter/view/home/home_vc.dart';
import 'package:focus_tube_flutter/view/home/search_vc.dart';
import 'package:focus_tube_flutter/view/home/playlist_vc.dart';
import 'package:focus_tube_flutter/view/home/channels_vc.dart';
import 'package:focus_tube_flutter/view/home/settings_vc.dart';
import 'controller/app_controller.dart';
import 'view/content_vc.dart';

// MARK: Navigation Model
class AppNavigationModel {
  final String label;
  final String path;
  final String? name;
  final IconData? icon;
  final Widget Function(BuildContext, GoRouterState) builder;

  const AppNavigationModel({
    required this.label,
    required this.path,
    required this.builder,
    this.name,
    this.icon,
  });

  /// Build route with parameter support
  String route({dynamic id}) {
    if (id != null && path.contains('/:id')) {
      return path.replaceFirst(':id', id.toString());
    }
    return path;
  }

  /// Convert model to [GoRoute]
  GoRoute toGoRoute({List<RouteBase> routes = const []}) {
    return GoRoute(
      path: path,
      name: name,
      routes: routes,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: builder(context, state)),
    );
  }

  // Navigation helpers
  Future<T?> go<T>(BuildContext context, {dynamic id, Object? extra}) {
    return context.push<T>(route(id: id), extra: extra);
  }

  void off(BuildContext context, {dynamic id, Object? extra}) {
    context.go(route(id: id), extra: extra);
  }

  Future<T?> replace<T>(BuildContext context, {dynamic id, Object? extra}) {
    if (context.canPop() && !kIsWeb) {
      context.pop();
    }
    return go<T>(context, id: id, extra: extra);
  }

  static void untilFirst(BuildContext context) {
    final history = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.matches;
    for (var i = 1; i < history.length; i++) {
      if (context.canPop()) context.pop();
    }
  }
}

// MARK: No Transition Page
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  const NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
         transitionsBuilder: _builder,
         transitionDuration: Duration.zero,
         reverseTransitionDuration: Duration.zero,
       );

  static Widget _builder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

/// MARK: Extension on BuildContext
extension AppNavigator on BuildContext {
  Future<T?> pushPage<T>(String location, {Object? extra}) async {
    if (kIsWeb) {
      go(location, extra: extra);
      return null;
    }
    return push<T>(location, extra: extra);
  }
}

// MARK: Screen Route Variables
final AppNavigationModel onboarding = AppNavigationModel(
  label: "Onboarding",
  path: OnboardingVC.id,
  builder: (context, state) => const OnboardingVC(),
);

final AppNavigationModel signUp = AppNavigationModel(
  label: "Sign Up",
  path: CreateAccountVC.id,
  builder: (context, state) => const CreateAccountVC(),
);

final AppNavigationModel signIn = AppNavigationModel(
  label: "Sign In",
  path: LoginVC.id,
  builder: (context, state) => const LoginVC(),
);

final AppNavigationModel forgotPassword = AppNavigationModel(
  label: "Forgot Password",
  path: ForgotPasswordVC.id,
  builder: (context, state) => const ForgotPasswordVC(),
);

final AppNavigationModel emailVerification = AppNavigationModel(
  label: "Email Verification",
  path: VerificationVC.id,
  builder: (context, state) => const VerificationVC(),
);

final AppNavigationModel forgotPasswordVerification = AppNavigationModel(
  label: "Forgot Password Verification",
  path: "${VerificationVC.forgotPasswordId}/:id",
  builder: (context, state) => VerificationVC(
    isFromForgotPassword: true,
    email: EncryptService.decrypt(state.pathParameters['id']!),
  ),
);

final AppNavigationModel resetPassword = AppNavigationModel(
  label: "Reset Password",
  path: "${ResetPasswordVC.id}/:id",
  builder: (context, state) {
    var data = jsonDecode(EncryptService.decrypt(state.pathParameters['id']!));

    return ResetPasswordVC(email: data['email'], code: data['code']);
  },
);

final AppNavigationModel content = AppNavigationModel(
  label: "Content",
  path: "${ContentVC.id}/:id",
  builder: (context, state) =>
      ContentVC(slug: state.pathParameters['id'] ?? ''),
);
final AppNavigationModel changePassword = AppNavigationModel(
  label: "Change Password",
  path: ChangePasswordVC.id,
  builder: (context, state) => const ChangePasswordVC(),
);
final AppNavigationModel chooseYourInteres = AppNavigationModel(
  label: "Choose Your Interest",
  path: ChooseYourInterestVC.id,
  builder: (context, state) => ChooseYourInterestVC(),
);
final AppNavigationModel editYourInterest = AppNavigationModel(
  label: "Edit Your Interest",
  path: ChooseYourInterestVC.editId,
  builder: (context, state) => ChooseYourInterestVC(isFromEdit: true),
);
final AppNavigationModel dailyLimit = AppNavigationModel(
  label: "Daily Limits",
  path: DailyLimitVC.id,
  builder: (context, state) => DailyLimitVC(),
);
final AppNavigationModel editDailyLimit = AppNavigationModel(
  label: "Edit Daily Limits",
  path: DailyLimitVC.editId,
  builder: (context, state) => DailyLimitVC(isFromEdit: true),
);
final AppNavigationModel home = AppNavigationModel(
  label: "Home",
  path: HomeVC.id,
  builder: (context, state) => const HomeVC(),
);

final AppNavigationModel search = AppNavigationModel(
  label: "Search",
  path: SearchVC.id,
  builder: (context, state) => const SearchVC(),
);
final AppNavigationModel playlists = AppNavigationModel(
  label: "Playlists",
  path: PlaylistVC.id,
  builder: (context, state) => const PlaylistVC(),
);
final AppNavigationModel playListDetail = AppNavigationModel(
  label: "Playlist Detail",
  path: "${PlaylistVC.id}${PlayListDetailVC.id}",
  builder: (context, state) =>
      PlayListDetailVC(playListId: state.pathParameters['id'] ?? ""),
);
final AppNavigationModel channels = AppNavigationModel(
  label: "Channels",
  path: ChannelsVC.id,
  builder: (context, state) => const ChannelsVC(),
);
final AppNavigationModel myChannels = AppNavigationModel(
  label: "My Channels",
  path: MyChannelsVC.id,
  builder: (context, state) => const MyChannelsVC(),
);
final AppNavigationModel channelDetail = AppNavigationModel(
  label: "Channel Detail",
  path: "${ChannelsVC.id}${ChannelDetailVC.id}",
  builder: (context, state) =>
      ChannelDetailVC(channelId: state.pathParameters['id'] ?? ""),
);
final AppNavigationModel settings = AppNavigationModel(
  label: "Settings",
  path: SettingsVC.id,
  builder: (context, state) => const SettingsVC(),
);
final AppNavigationModel subjects = AppNavigationModel(
  label: "Subjects",
  path: SubjectVC.id,
  builder: (context, state) => SubjectVC(),
);
final AppNavigationModel mySubjects = AppNavigationModel(
  label: "My Subjects",
  path: SubjectVC.mySubjectId,
  builder: (context, state) => SubjectVC(isMySubjects: true),
);
final AppNavigationModel selectSubjects = AppNavigationModel(
  label: "Select Subjects",
  path: SelectSubjectVC.id,
  builder: (context, state) => SelectSubjectVC(),
);
final AppNavigationModel subjectsDetail = AppNavigationModel(
  label: "Subject Details",
  path: SubjectDetailVC.id,
  builder: (context, state) => SubjectDetailVC(title: state.extra as String),
);
final AppNavigationModel videos = AppNavigationModel(
  label: "Videos",
  path: VideoListVC.id,
  builder: (context, state) => VideoListVC(title: state.extra as String),
);
final AppNavigationModel videoDetail = AppNavigationModel(
  label: "Video Details",
  path: VideoDetailVC.id,
  builder: (context, state) => VideoDetailVC(),
);
final AppNavigationModel youtubeVideoDetail = AppNavigationModel(
  label: "Youtube Video Details",
  path: VideoDetailVC.youtubeId,
  builder: (context, state) => VideoDetailVC(isFromYoutube: true),
);
final AppNavigationModel notes = AppNavigationModel(
  label: "Notes",
  path: NoteListVC.id,
  builder: (context, state) => NoteListVC(),
);
final AppNavigationModel addNote = AppNavigationModel(
  label: "Add Note",
  path: "${NoteListVC.id}${NoteDetailVC.addId}",
  builder: (context, state) => NoteDetailVC(),
);
final AppNavigationModel detailsNote = AppNavigationModel(
  label: "Note Detail",
  path: "${NoteListVC.id}${NoteDetailVC.detailId}",
  builder: (context, state) => NoteDetailVC(id: state.pathParameters['id']),
);
final AppNavigationModel profile = AppNavigationModel(
  label: "My Profile",
  path: ProfileVC.id,
  builder: (context, state) => ProfileVC(),
);
final AppNavigationModel editProfile = AppNavigationModel(
  label: "Edit Profile",
  path: ProfileVC.editid,
  builder: (context, state) => ProfileVC(isFromEdit: true),
);

final AppNavigationModel selectChannels = AppNavigationModel(
  label: "Select Channels",
  path: AddChannelsVC.id,
  builder: (context, state) => AddChannelsVC(),
);
final AppNavigationModel dailyGoal = AppNavigationModel(
  label: "Daily Goals",
  path: DailyGoalVC.id,
  builder: (context, state) => DailyGoalVC(),
);
final AppNavigationModel setDailyGoal = AppNavigationModel(
  label: "Set Daily Goals",
  path: SetDailyGoalVC.id,
  builder: (context, state) => SetDailyGoalVC(),
);
// MARK: Router
final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
List<AppNavigationModel> authNavigation = [
  onboarding,
  signUp,
  signIn,
  forgotPassword,
  forgotPasswordVerification,
  resetPassword,
  content,
];
final GoRouter router = GoRouter(
  navigatorKey: navigationKey,
  initialLocation: onboarding.path,
  routes: [
    ...[
      ...authNavigation, emailVerification,
      chooseYourInteres,
      editYourInterest,
      dailyLimit,
      videos,
      playlists,
      changePassword,
      //  subjects,
      mySubjects,
      subjectsDetail,
      videoDetail,
      notes,
      addNote,
      detailsNote,
      playListDetail,
      channelDetail,
      profile,
      editProfile,
      myChannels,
      editDailyLimit,
      selectChannels,
      //dailyGoal,
      youtubeVideoDetail,
      setDailyGoal,
      selectSubjects,
      youtubeVideoDetail, settings,
    ].map((routeElement) => routeElement.toGoRoute()),
    StatefulShellRoute.indexedStack(
      branches: [
        home,
        search,
        subjects,
        channels,
        //settings,
        dailyGoal,
      ].map((e) => StatefulShellBranch(routes: [e.toGoRoute()])).toList(),
      pageBuilder: (context, state, navigationShell) => MaterialPage(
        key: state.pageKey,
        child: HomeRoot(navigationShell: navigationShell),
      ),
    ),
  ],
  redirect: (context, state) {
    var authCtrl = controller<UserController>();
    var interestCtrl = controller<InterestController>();
    if (authCtrl.user == null) {
      if (authNavigation.where((e) => e.path == state.fullPath).isNotEmpty) {
        return state.path;
      }
      return onboarding.path;
    } else if (authCtrl.user?.emailActive != "y") {
      return emailVerification.path;
    } else if (interestCtrl.userInterests.isEmpty) {
      return chooseYourInteres.path;
    } else if ((int.tryParse(
              authCtrl.user?.preference?.dailyVideoLimit ?? "0",
            ) ??
            0) ==
        0) {
      return dailyLimit.path;
    }
    return state.path;
  },
);
