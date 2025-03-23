import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../services/ai_profile_submission_service.dart';
import '../../utils/bottom_nav_bar_widget.dart';
import 'widgets/section_title.dart';
import 'widgets/styled_text_field.dart';
import 'widgets/into_card.dart';

@RoutePage()
class CreateAIProfileScreen extends StatefulWidget {
  const CreateAIProfileScreen({super.key});

  @override
  State<CreateAIProfileScreen> createState() => _CreateAIProfileScreenState();
}

class _CreateAIProfileScreenState extends State<CreateAIProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _personalityController = TextEditingController();
  final _writingStyleController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _personalityController.dispose();
    _writingStyleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create AI Profile'),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction card
                  const IntroCard(),

                  const SizedBox(height: 24),
                  
                  // Name field
                  const SectionTitle(title: 'Name'),
                  const SizedBox(height: 8),
                  StyledTextField(
                    controller: _nameController,
                    hintText: 'What would you like to name your AI?',
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  
                  // Personality field
                  const SectionTitle(title: 'Personality'),
                  const SizedBox(height: 8),
                  StyledTextField(
                    controller: _personalityController,
                    hintText: 'Friendly, helpful, knowledgeable...',
                    helperText: 'Describe the personality traits of your AI (e.g., friendly, formal, humorous)',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe the personality';
                      }
                      if (value.length < 10) {
                        return 'Please provide more detail (at least 10 characters)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  
                  // Writing style field
                  const SectionTitle(title: 'Writing Style'),
                  const SizedBox(height: 8),
                  StyledTextField(
                    controller: _writingStyleController,
                    hintText: 'Concise and informative with occasional humor...',
                    helperText: 'How should your AI communicate? (e.g., concise, detailed, casual)',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe the writing style';
                      }
                      if (value.length < 10) {
                        return 'Please provide more detail (at least 10 characters)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitAIProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'CREATE AI PROFILE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const BottomNavWidget(currentIndex: 1),
        ],
      ),
    );
  }

  Future<void> _submitAIProfile() async {
    await ProfileSubmissionService.submitAIProfile(
      context: context,
      formKey: _formKey,
      nameController: _nameController,
      personalityController: _personalityController,
      writingStyleController: _writingStyleController,
      setLoadingState: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
    );
  }
}