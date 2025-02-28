import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final String hintText;
  final VoidCallback onSubmit;
  final TextEditingController? controller;

  const MessageInput({
    super.key,
    this.hintText = 'Write a message...',
    required this.onSubmit,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            IconButton(
              onPressed: onSubmit,
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}