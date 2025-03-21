import 'package:ai_social_network/screens/create_content_screen/widgets/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../../provider/post_provider.dart';
import '../../provider/discussions_provider.dart';
import '../../routes/app_router.dart';
import './widgets/input_label.dart';

enum ContentType {
  post,
  discussion
}

@RoutePage()
class CreateContentScreen extends StatefulWidget {
  const CreateContentScreen({super.key});

  @override
  State<CreateContentScreen> createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  ContentType _selectedType = ContentType.post;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTypeSelected(ContentType type) {
    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.router.push(const HomeRoute()), 
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TypeSelector(
                      type: ContentType.post,
                      selectedType: _selectedType,
                      icon: Icons.post_add,
                      label: 'Post',
                      description: 'Share your thoughts',
                      onTypeSelected: _onTypeSelected,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TypeSelector(
                      type: ContentType.discussion,
                      selectedType: _selectedType,
                      icon: Icons.forum,
                      label: 'Discussion',
                      description: 'Start a conversation',
                      onTypeSelected: _onTypeSelected,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedType == ContentType.discussion) ...[
                    const InputLabel(label: 'Title'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'What is this discussion about?',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                  ],

                  InputLabel(
                    label: _selectedType == ContentType.post ? 'What\'s on your mind?' : 'Details'
                  ),
                  
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: _selectedType == ContentType.post
                          ? "Share your thoughts with the community..."
                          : "Describe your topic in detail...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    minLines: 8,
                    maxLines: 15,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitContent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'PUBLISH ${_selectedType == ContentType.post ? 'POST' : 'DISCUSSION'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitContent() async {
    if (_selectedType == ContentType.discussion && _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title for your discussion')),
      );
      return;
    }

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    bool success = false;

    try {
      if (_selectedType == ContentType.post) {
        success = await context.read<PostsProvider>().createPost(content);
      } else {
        success = await context.read<DiscussionsProvider>().createDiscussion(
          _titleController.text.trim(), 
          content
        );
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_selectedType == ContentType.post ? 'Post' : 'Discussion'} created successfully')),
          );

          if (_selectedType == ContentType.post) {
            context.router.replaceAll([const HomeRoute()]);
          } else {
            context.router.replaceAll([const DiscussionRoute()]);
          }
        } else {
          final errorMessage = _selectedType == ContentType.post 
              ? context.read<PostsProvider>().error 
              : context.read<DiscussionsProvider>().error;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${errorMessage ?? "Unknown error occurred"}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}