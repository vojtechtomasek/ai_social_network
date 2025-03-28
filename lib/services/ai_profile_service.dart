import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/ai_profile_provider.dart';
import '../models/ai_profile_model.dart';

class AiProfileService {

  static Future<void> submitAIProfile({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController personalityController,
    required TextEditingController writingStyleController,
    required void Function(bool) setLoadingState,
  }) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setLoadingState(true);

    try {
      final success = await context.read<AIProfileProvider>().createAIProfile(
        name: nameController.text.trim(),
        personality: personalityController.text.trim(),
        writingStyle: writingStyleController.text.trim(),
      );

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('AI profile created successfully')),
          );
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
      if (context.mounted) {
        setLoadingState(false);
      }
    }
  }

  static Future<void> deleteAIProfile({
    required BuildContext context,
    required AIProfileModel profile,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete AI Profile'),
        content: Text('Are you sure you want to delete "${profile.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleting profile...'))
      );
    }

    try {
      final success = await context.read<AIProfileProvider>().deleteProfile(profile.id);
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${profile.name} has been deleted'))
          );
          context.read<AIProfileProvider>().fetchProfiles();
        } else {
          final error = context.read<AIProfileProvider>().error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete profile: $error'))
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
        );
      }
    }
  }
}