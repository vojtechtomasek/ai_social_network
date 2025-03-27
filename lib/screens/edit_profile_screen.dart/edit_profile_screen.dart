import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/profile_provider.dart';
import 'widgets/form_field_with_label.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _localLoading = false;

  @override
  void initState() {
    super.initState();
    _populateFieldsFromProvider();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _populateFieldsFromProvider() {
    final profileProvider = context.read<ProfileProvider>();
    
    if (profileProvider.userData != null) {
      setState(() {
        _firstNameController.text = profileProvider.userData!['first_name'] ?? '';
        _lastNameController.text = profileProvider.userData!['last_name'] ?? '';
        _userNameController.text = profileProvider.userData!['user_name'] ?? '';
        _bioController.text = profileProvider.userData!['bio'] ?? '';
      });
    } else {
      profileProvider.loadUserData().then((_) {
        if (mounted && profileProvider.userData != null) {
          setState(() {
            _firstNameController.text = profileProvider.userData!['first_name'] ?? '';
            _lastNameController.text = profileProvider.userData!['last_name'] ?? '';
            _userNameController.text = profileProvider.userData!['user_name'] ?? '';
            _bioController.text = profileProvider.userData!['bio'] ?? '';
          });
        }
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _localLoading = true);

    final profileProvider = context.read<ProfileProvider>();
    
    final success = await profileProvider.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      userName: _userNameController.text.trim(),
      bio: _bioController.text.trim(),
    );

    if (mounted) {
      setState(() => _localLoading = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        context.router.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${profileProvider.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = _localLoading || profileProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Change profile picture not implemented yet')),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, size: 50, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    FormFieldWithLabel(
                      label: 'First Name', 
                      hintText: 'Enter your first name', 
                      controller: _firstNameController, 
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      }
                    ),
                    
                    const SizedBox(height: 16),
                    
                    FormFieldWithLabel(
                      label: 'Last Name', 
                      hintText: 'Enter your last name', 
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    FormFieldWithLabel(
                      label: 'Username', 
                      hintText: 'Enter your username', 
                      controller: _userNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        if (value.contains(' ')) {
                          return 'Username cannot contain spaces';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    
                    FormFieldWithLabel(
                      label: 'Bio', 
                      hintText: 'Tell us about yourself', 
                      controller: _bioController,
                      maxLines: 3
                    ),

                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}