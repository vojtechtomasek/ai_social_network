import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.smart_toy, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              'Create Your AI Companion',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Define your AI\'s personality and writing style to create a unique virtual companion that reflects your preferences.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}