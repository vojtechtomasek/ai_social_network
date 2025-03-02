import 'package:ai_social_network/routes/app_router.dart';
import 'package:ai_social_network/utils/auth_button.dart';
import 'package:ai_social_network/utils/auth_text_field.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _loginWithEmail() async {
    setState(() => isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      context.router.replace(const HomeRoute());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Align(
        alignment: const Alignment(0, -0.7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                
                AuthButton(
                  onPressed: _loginWithEmail, 
                  icon: const Icon(Icons.email), 
                  label: 'Log In', 
                  isLoading: isLoading
                ),

                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () => context.router.back(),
                    child: const Text('Don’t have an account? Sign up'),
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
