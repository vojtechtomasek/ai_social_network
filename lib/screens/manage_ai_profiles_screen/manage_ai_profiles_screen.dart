import 'package:ai_social_network/services/ai_profile_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/ai_profile_provider.dart';
import '../../routes/app_router.dart';

@RoutePage()
class ManageAIProfilesScreen extends StatefulWidget {
  const ManageAIProfilesScreen({super.key});

  @override
  State<ManageAIProfilesScreen> createState() => _ManageAIProfilesScreenState();
}

class _ManageAIProfilesScreenState extends State<ManageAIProfilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AIProfileProvider>().fetchProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<AIProfileProvider>();
    final profiles = profileProvider.profiles;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage AI Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.router.push(const CreateAIProfileRoute()),
          ),
        ],
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${profileProvider.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => profileProvider.fetchProfiles(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : profiles.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.smart_toy_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No AI profiles yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create an AI profile to get started',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      child: const Icon(Icons.smart_toy, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        profile.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () async {
                                        final result = await context.router.push(
                                          EditAIProfileRoute(profile: profile)
                                        );
                                        

                                        if (result == true) {
                                          context.read<AIProfileProvider>().fetchProfiles();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => AiProfileService.deleteAIProfile(
                                        context: context,
                                        profile: profile,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Personality: ${profile.personality}',
                                  style: const TextStyle(color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Writing Style: ${profile.writingStyle}',
                                  style: const TextStyle(color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}