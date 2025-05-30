// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CreateAIProfileScreen]
class CreateAIProfileRoute extends PageRouteInfo<void> {
  const CreateAIProfileRoute({List<PageRouteInfo>? children})
      : super(
          CreateAIProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAIProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateAIProfileScreen();
    },
  );
}

/// generated route for
/// [CreateContentScreen]
class CreateContentRoute extends PageRouteInfo<void> {
  const CreateContentRoute({List<PageRouteInfo>? children})
      : super(
          CreateContentRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateContentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateContentScreen();
    },
  );
}

/// generated route for
/// [DiscussionDetailScreen]
class DiscussionDetailRoute extends PageRouteInfo<DiscussionDetailRouteArgs> {
  DiscussionDetailRoute({
    dynamic key,
    required String discussionId,
    required String discussionName,
    required int numberOfPosts,
    required String createdBy,
    required bool isAi,
    required String message,
    required DateTime timestamp,
    List<PageRouteInfo>? children,
  }) : super(
          DiscussionDetailRoute.name,
          args: DiscussionDetailRouteArgs(
            key: key,
            discussionId: discussionId,
            discussionName: discussionName,
            numberOfPosts: numberOfPosts,
            createdBy: createdBy,
            isAi: isAi,
            message: message,
            timestamp: timestamp,
          ),
          initialChildren: children,
        );

  static const String name = 'DiscussionDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DiscussionDetailRouteArgs>();
      return DiscussionDetailScreen(
        key: args.key,
        discussionId: args.discussionId,
        discussionName: args.discussionName,
        numberOfPosts: args.numberOfPosts,
        createdBy: args.createdBy,
        isAi: args.isAi,
        message: args.message,
        timestamp: args.timestamp,
      );
    },
  );
}

class DiscussionDetailRouteArgs {
  const DiscussionDetailRouteArgs({
    this.key,
    required this.discussionId,
    required this.discussionName,
    required this.numberOfPosts,
    required this.createdBy,
    required this.isAi,
    required this.message,
    required this.timestamp,
  });

  final dynamic key;

  final String discussionId;

  final String discussionName;

  final int numberOfPosts;

  final String createdBy;

  final bool isAi;

  final String message;

  final DateTime timestamp;

  @override
  String toString() {
    return 'DiscussionDetailRouteArgs{key: $key, discussionId: $discussionId, discussionName: $discussionName, numberOfPosts: $numberOfPosts, createdBy: $createdBy, isAi: $isAi, message: $message, timestamp: $timestamp}';
  }
}

/// generated route for
/// [DiscussionScreen]
class DiscussionRoute extends PageRouteInfo<void> {
  const DiscussionRoute({List<PageRouteInfo>? children})
      : super(
          DiscussionRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiscussionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DiscussionScreen();
    },
  );
}

/// generated route for
/// [EditAIProfileScreen]
class EditAIProfileRoute extends PageRouteInfo<EditAIProfileRouteArgs> {
  EditAIProfileRoute({
    dynamic key,
    required AIProfileModel profile,
    List<PageRouteInfo>? children,
  }) : super(
          EditAIProfileRoute.name,
          args: EditAIProfileRouteArgs(
            key: key,
            profile: profile,
          ),
          initialChildren: children,
        );

  static const String name = 'EditAIProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditAIProfileRouteArgs>();
      return EditAIProfileScreen(
        key: args.key,
        profile: args.profile,
      );
    },
  );
}

class EditAIProfileRouteArgs {
  const EditAIProfileRouteArgs({
    this.key,
    required this.profile,
  });

  final dynamic key;

  final AIProfileModel profile;

  @override
  String toString() {
    return 'EditAIProfileRouteArgs{key: $key, profile: $profile}';
  }
}

/// generated route for
/// [EditProfileScreen]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
      : super(
          EditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfileScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [ManageAIProfilesScreen]
class ManageAIProfilesRoute extends PageRouteInfo<void> {
  const ManageAIProfilesRoute({List<PageRouteInfo>? children})
      : super(
          ManageAIProfilesRoute.name,
          initialChildren: children,
        );

  static const String name = 'ManageAIProfilesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManageAIProfilesScreen();
    },
  );
}

/// generated route for
/// [PostDetailScreen]
class PostDetailRoute extends PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({
    dynamic key,
    required String postId,
    required String sender,
    required String message,
    required DateTime timestamp,
    bool isAi = false,
    List<PageRouteInfo>? children,
  }) : super(
          PostDetailRoute.name,
          args: PostDetailRouteArgs(
            key: key,
            postId: postId,
            sender: sender,
            message: message,
            timestamp: timestamp,
            isAi: isAi,
          ),
          initialChildren: children,
        );

  static const String name = 'PostDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PostDetailRouteArgs>();
      return PostDetailScreen(
        key: args.key,
        postId: args.postId,
        sender: args.sender,
        message: args.message,
        timestamp: args.timestamp,
        isAi: args.isAi,
      );
    },
  );
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({
    this.key,
    required this.postId,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isAi = false,
  });

  final dynamic key;

  final String postId;

  final String sender;

  final String message;

  final DateTime timestamp;

  final bool isAi;

  @override
  String toString() {
    return 'PostDetailRouteArgs{key: $key, postId: $postId, sender: $sender, message: $message, timestamp: $timestamp, isAi: $isAi}';
  }
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}
