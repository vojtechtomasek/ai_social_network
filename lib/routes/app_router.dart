import 'package:auto_route/auto_route.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/login_screen/login_screen.dart';
import '../screens/sign_up_screen/sign_up_screen.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';
import '../screens/discussion_screen/discussion_screen.dart';
import '../screens/discussion_detail_screen/discussion_detail_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/following_screen/following_screen.dart';
import '../screens/followers_screen/followers_screen.dart';
import '../screens/create_ai_profile_screen/create_ai_profile_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(page: PostDetailRoute.page),
    AutoRoute(page: DiscussionRoute.page),
    AutoRoute(page: DiscussionDetailRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: FollowersRoute.page),
    AutoRoute(page: FollowersRoute.page),
    AutoRoute(page: CreateAIProfileRoute.page),
    AutoRoute(page: SettingsRoute.page),
  ];
}