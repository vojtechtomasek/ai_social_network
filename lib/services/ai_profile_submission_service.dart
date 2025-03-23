import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/ai_profile_provider.dart';

class ProfileSubmissionService {
  static Future<void> submitAIProfile({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController personalityController,
    required TextEditingController writingStyleController,
    required void Function(bool) setLoadingState,
  }) async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Start loading
    setLoadingState(true);

    try {
      // Submit to provider
      final success = await context.read<AIProfileProvider>().createAIProfile(
        name: nameController.text.trim(),
        personality: personalityController.text.trim(),
        writingStyle: writingStyleController.text.trim(),
      );

      // Handle result
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI profile created successfully')),
          );
          // Clear fields on success
          nameController.clear();
          personalityController.clear();
          writingStyleController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${context.read<AIProfileProvider>().error ?? "Unknown error"}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      // End loading
      if (context.mounted) {
        setLoadingState(false);
      }
    }
  }
}