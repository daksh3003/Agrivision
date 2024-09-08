import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class CommunityPage extends StatefulWidget {
  CommunityPage({Key? key}) : super(key: key); // Constructor

  @override
  _CommunityPageState createState() => _CommunityPageState();
}


class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _questionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Simulated posts data
  List<Map<String, dynamic>> posts = [];

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to post question
  void _postQuestion() {
    if (_questionController.text.isEmpty && _selectedImage == null) return;

    setState(() {
      posts.add({
        'question': _questionController.text,
        'image': _selectedImage,
        'comments': []
      });
      _questionController.clear();
      _selectedImage = null;
    });
  }

  // Function to add comment
  void _addComment(int postIndex, String comment) {
    setState(() {
      posts[postIndex]['comments'].add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Column(
        children: [
          // Post question section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Ask a question...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Add Image'),
                    ),
                    const SizedBox(width: 10),
                    _selectedImage != null
                        ? Image.file(
                      _selectedImage!,
                      width: 50,
                      height: 50,
                    )
                        : Container(),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _postQuestion,
                  child: Text('Post Question'),
                ),
              ],
            ),
          ),
          const Divider(),

          // Display questions and comments
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post['question'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        if (post['image'] != null)
                          Image.file(
                            post['image'],
                            width: 100,
                            height: 100,
                          ),
                        const SizedBox(height: 8.0),
                        // Display comments
                        ListView.builder(
                          itemCount: post['comments'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, commentIndex) {
                            return ListTile(
                              title: Text(post['comments'][commentIndex]),
                            );
                          },
                        ),
                        const Divider(),
                        // Add a comment section
                        CommentSection(
                          postIndex: index,
                          addComment: _addComment,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  final int postIndex;
  final Function(int, String) addComment;

  CommentSection({required this.postIndex, required this.addComment});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            widget.addComment(widget.postIndex, _commentController.text);
            _commentController.clear();
          },
        ),
      ],
    );
  }
}
