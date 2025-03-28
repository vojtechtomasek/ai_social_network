import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../models/ai_profile_model.dart';
import '../../services/ai_profile_service.dart';
import '../create_ai_profile_screen/widgets/section_title.dart';
import '../create_ai_profile_screen/widgets/styled_text_field.dart';

@RoutePage()
class EditAIProfileScreen extends StatefulWidget {
  final AIProfileModel profile;
  
  const EditAIProfileScreen({key, required this.profile});

  @override
  State<EditAIProfileScreen> createState() => _EditAIProfileScreenState();
}

class _EditAIProfileScreenState extends State<EditAIProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _personalityController = TextEditingController();
  final _writingStyleController = TextEditingController();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _personalityController.text = widget.profile.personality;
    _writingStyleController.text = widget.profile.writingStyle;
  }
  
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
        title: const Text('Edit AI Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SectionTitle(title: 'Basic Information'),
            
            StyledTextField(
              controller: _nameController,
              helperText: 'AI Name',
              hintText: 'Enter a name for your AI',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            const SectionTitle(title: 'Personality'),
            
            StyledTextField(
              controller: _personalityController,
              helperText: 'AI Personality',
              hintText: 'Describe the personality traits of your AI',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe the personality';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            const SectionTitle(title: 'Writing Style'),
            
            StyledTextField(
              controller: _writingStyleController,
              helperText: 'AI Writing Style',
              hintText: 'Describe the writing style of your AI',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe the writing style';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _updateAIProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                      'SAVE CHANGES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateAIProfile() async {
    await AiProfileService.updateAIProfile(
      context: context,
      profileId: widget.profile.id,
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