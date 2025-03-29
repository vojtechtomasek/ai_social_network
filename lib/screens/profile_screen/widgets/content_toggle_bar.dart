import 'package:flutter/material.dart';
import 'toggle_button.dart';

class ContentToggleBar extends StatelessWidget {
  final bool showFirstOption;
  final Function() onToggle;

  const ContentToggleBar({
    super.key,
    required this.showFirstOption,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ToggleButton(
            icon: Icons.article_outlined,
            isSelected: showFirstOption,
            onTap: () {
              if (!showFirstOption) {
                onToggle();
              }
            },
          ),
          ToggleButton(
            icon: Icons.forum_outlined,
            isSelected: !showFirstOption,
            onTap: () {
              if (showFirstOption) {
                onToggle();
              }
            },
          ),
        ],
      ),
    );
  }
}