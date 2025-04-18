import 'package:ai_social_network/routes/app_router.dart';
import 'package:ai_social_network/utils/auth_button.dart';
import 'package:ai_social_network/utils/auth_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/user_model.dart';

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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
    _checkSession();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    super.dispose();
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

  Future<void> _createUserProfile({
    required String userId,
    required String email,
    String? firstName,
    String? lastName,
    String? userName,
    String? bio,
  }) async {
    try {
      final user = UserModel(
        id: userId,
        email: email,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        userName: userName ?? '',
        bio: bio ?? '',
      );
  
      await supabase.from('users').insert(user.toMap());
      print('Profile created successfully for user: $userId');
    } catch (e) {
      print('Error creating user profile: $e');
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
        await _createUserProfile(
          userId: response.user!.id,
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          userName: _emailController.text.split('@')[0],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Check your email to verify your account.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken!,
    );

    if (response.user != null) {
      final email = googleUser?.email;
      final fullName = googleUser?.displayName ?? '';
      String firstName = '';
      String lastName = '';

      if (fullName.contains(' ')) {
        firstName = fullName.split(' ').first;
        lastName = fullName.split(' ').last;
      } else {
        firstName = fullName;
      }

      await _createUserProfile(
        userId: response.user!.id,
        email: email ?? '',
        firstName: firstName,
        lastName: lastName,
        userName: email?.split('@')[0],
      );
    }

    return response;
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
                    icon: const Icon(
                      Icons.g_mobiledata_sharp,
                      size: 30,
                    ),
                    label: 'Sign Up with Google'),

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

                // First name and last name fields
                AuthTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hintText: 'First Name'),

                const SizedBox(height: 16),

                AuthTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hintText: 'Last Name'),

                const SizedBox(height: 16),

                // Email and password fields
                AuthTextField(
                    controller: _emailController,
                    label: 'Your Email',
                    hintText: 'Email'),

                const SizedBox(height: 16),

                AuthTextField(
                    controller: _passwordController,
                    label: 'Your Password',
                    hintText: 'Password',
                    obscureText: true),

                const SizedBox(height: 20),

                // Email sign up button
                AuthButton(
                  onPressed: _signUpWithEmail,
                  icon: const Icon(
                    Icons.email,
                    size: 20,
                  ),
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
