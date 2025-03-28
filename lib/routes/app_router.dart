import 'package:ai_social_network/screens/manage_ai_profiles_screen/manage_ai_profiles_screen.dart';

import '../screens/create_content_screen/create_content_screen.dart';
import '../screens/edit_profile_screen.dart/edit_profile_screen.dart';
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

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(page: HomeRoute.page, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(page: CreateAIProfileRoute.page, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(page: DiscussionRoute.page, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(page: ProfileRoute.page, transitionsBuilder: TransitionsBuilders.noTransition),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page, initial: true),
    AutoRoute(page: PostDetailRoute.page),
    AutoRoute(page: DiscussionDetailRoute.page),
    AutoRoute(page: FollowersRoute.page),
    AutoRoute(page: FollowersRoute.page),
    AutoRoute(page: CreateContentRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: ManageAIProfilesRoute.page),
  ];
}