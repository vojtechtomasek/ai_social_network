import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/saved_content_provider.dart';

class BookmarkButton extends StatefulWidget {
  final String? postId;
  final String? discussionId;
  
  const BookmarkButton({
    super.key,
    this.postId,
    this.discussionId,
  }) : assert(postId != null || discussionId != null, 'Either postId or discussionId must be provided');

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool _isSaved = false;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }
  
  Future<void> _checkIfSaved() async {
    final provider = context.read<SavedContentProvider>();
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (widget.postId != null) {
        _isSaved = await provider.isPostSaved(widget.postId!);
      } else if (widget.discussionId != null) {
        _isSaved = await provider.isDiscussionSaved(widget.discussionId!);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _toggleSaved() async {
    final provider = context.read<SavedContentProvider>();
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      bool success;
      
      if (widget.postId != null) {
        success = _isSaved 
            ? await provider.unsavePost(widget.postId!)
            : await provider.savePost(widget.postId!);
      } else if (widget.discussionId != null) {
        success = _isSaved 
            ? await provider.unsaveDiscussion(widget.discussionId!)
            : await provider.saveDiscussion(widget.discussionId!);
      } else {
        success = false;
      }
      
      if (success && mounted) {
        setState(() {
          _isSaved = !_isSaved;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSaved 
                ? 'Added to saved items' 
                : 'Removed from saved items'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? Theme.of(context).primaryColor : null,
            ),
      onPressed: _isLoading ? null : _toggleSaved,
      tooltip: _isSaved ? 'Remove from saved' : 'Save',
    );
  }
}