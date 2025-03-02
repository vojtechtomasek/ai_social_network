import 'package:ai_social_network/routes/app_router.dart';
import 'package:ai_social_network/utils/auth_button.dart';
import 'package:ai_social_network/utils/auth_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
    _checkSession();
  }

  void _setupAuthListener() {
  supabase.auth.onAuthStateChange.listen((data) {
    if (!mounted) return;
    final event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      context.router.replace(const HomeRoute());
    }
  });
}

  Future<void> _checkSession() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      context.router.replace(const HomeRoute());
    }
  }

  Future<void> _signUpWithEmail() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (response.user?.id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email to verify your account.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<AuthResponse> _googleSignIn() async {
    final webClientId = dotenv.env['WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['IOS_CLIENT_ID'];

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth == null) throw 'Google Sign-In failed';

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Align(
        alignment: const Alignment(0.0, -0.7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Google button
                AuthButton(
                  onPressed: _googleSignIn, 
                  icon: const Icon(Icons.g_mobiledata_sharp, size: 30,), 
                  label: 'Sign Up with Google'
                ),

                const SizedBox(height: 24),
                
                // OR divider
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                
                // Email and password fields
                AuthTextField(
                  controller: _emailController, 
                  label: 'Your Email', 
                  hintText: 'Email'
                ),

                const SizedBox(height: 16),
                
                AuthTextField(
                  controller: _passwordController, 
                  label: 'Your Password', 
                  hintText: 'Password', 
                  obscureText: true
                ),

                const SizedBox(height: 20),
                
                // Email sign up button
                AuthButton(
                  onPressed: _signUpWithEmail, 
                  icon: const Icon(Icons.email, size: 20,), 
                  label: 'Sign Up with Email',
                  isLoading: isLoading,
                ),

                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () => context.router.push(const LoginRoute()),
                    child: const Text('Already have an account? Log in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
