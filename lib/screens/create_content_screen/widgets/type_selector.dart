import 'package:flutter/material.dart';
import '../create_content_screen.dart';

class TypeSelector extends StatelessWidget {
  final ContentType type;
  final ContentType selectedType;
  final IconData icon;
  final String label;
  final String description;
  final Function(ContentType) onTypeSelected;

  const TypeSelector({
    super.key,
    required this.type,
    required this.selectedType,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () {
        onTypeSelected(type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}