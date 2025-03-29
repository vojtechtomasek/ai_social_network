import 'package:ai_social_network/screens/profile_screen/widgets/saved_content_section.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/profile_provider.dart';
import '../../routes/app_router.dart';
import '../../utils/bottom_nav_bar_widget.dart';
import 'widgets/content_toggle_bar.dart';
import 'widgets/settings_menu.dart';
import '../../provider/saved_content_provider.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showingSavedPosts = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadUserData();
      _loadSavedContent();
    });
  }

  void _loadSavedContent() async {
    if (_showingSavedPosts) {
      await context.read<SavedContentProvider>().fetchSavedPosts();
    } else {
      await context.read<SavedContentProvider>().fetchSavedDiscussions();
    }
  }

  void _toggleSavedContent() {
    setState(() {
      _showingSavedPosts = !_showingSavedPosts;
    });
    _loadSavedContent();
  }

  void _signOut(BuildContext context) async {
    await context.read<ProfileProvider>().signOut();
    context.router.replace(const SignUpRoute());
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SettingsMenu(signOutFunction: _signOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.error != null
              ? Center(child: Text('Error: ${profileProvider.error}'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person,
                                  size: 50, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              profileProvider.userData?['user_name'] ??
                                  'No username available',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (profileProvider.userData?['bio'] != null &&
                                profileProvider.userData!['bio']
                                    .toString()
                                    .isNotEmpty)
                              Text(
                                profileProvider.userData!['bio'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Saved Content',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ContentToggleBar(
                              showFirstOption: _showingSavedPosts,
                              onToggle: _toggleSavedContent,
                            ),
                          ],
                        ),
                      ),
                      SavedContentSection(
                        showingSavedPosts: _showingSavedPosts,
                        loadSavedContent: _loadSavedContent,
                        buildEmptyState: _buildEmptyState,
                      )
                    ],
                  ),
                ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 4),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
