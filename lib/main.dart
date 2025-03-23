import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/ai_profile_provider.dart';
import 'provider/discussions_provider.dart';
import 'provider/post_provider.dart';
import 'provider/replies_provider.dart';
import 'routes/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(); 

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_API_KEY'] ?? '',
  );

  await SharedPreferences.getInstance();

  runApp(const MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => DiscussionsProvider()),
        ChangeNotifierProvider(create: (_) => RepliesProvider()),
        ChangeNotifierProvider(create: (_) => AIProfileProvider()),
    ],
    child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
      ),
    );

  }
}
