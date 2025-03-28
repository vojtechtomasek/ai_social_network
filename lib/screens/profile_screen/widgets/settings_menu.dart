import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_router.dart';
import 'settings_menu_item.dart';

class SettingsMenu extends StatelessWidget {
  final Function(BuildContext) signOutFunction;

  const SettingsMenu({
    super.key,
    required this.signOutFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 50,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SettingsMenuItem(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              Navigator.pop(context);
              context.router.push(const EditProfileRoute());
            },
          ),
          SettingsMenuItem(
            icon: Icons.smart_toy,
            title: 'Manage AI Profiles',
            onTap: () {
              Navigator.pop(context);
              context.router.push(const ManageAIProfilesRoute());
            },
          ),
          SettingsMenuItem(
            icon: Icons.notifications,
            title: 'Notification Settings',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification Settings not implemented yet')),
              );
            },
          ),
          const Divider(),
          SettingsMenuItem(
            icon: Icons.logout,
            title: 'Log Out',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              signOutFunction(context);
            },
          ),
        ],
      ),
    );
  }
}