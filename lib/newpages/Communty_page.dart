import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _questionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Function to pick image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Function to post question
  Future<void> _postQuestion() async {
    if (_questionController.text.isEmpty && _selectedImage == null) return;

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('community_images/${DateTime.now().millisecondsSinceEpoch}');

        final uploadTask = storageRef.putFile(_selectedImage!);

        // Handle upload progress
        uploadTask.snapshotEvents.listen((event) {
          print('Progress: ${event.bytesTransferred}/${event.totalBytes}');
        }).onError((error) {
          print('Upload error: $error');
        });

        final snapshot = await uploadTask;
        if (snapshot.state == TaskState.success) {
          imageUrl = await snapshot.ref.getDownloadURL();
        } else {
          print('Upload failed: ${snapshot.state}');
        }
      }

      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Anonymous';

      await FirebaseFirestore.instance.collection('community').add({
        'userId': userId,
        'question': _questionController.text.trim(),
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'comments': []
      });

      setState(() {
        _questionController.clear();
        _selectedImage = null;
      });
    } catch (e) {
      print('Error posting question: $e');
    }
  }

  // Function to fetch community posts from Firestore
  Stream<QuerySnapshot> _getCommunityPosts() {
    return FirebaseFirestore.instance.collection('community').orderBy('timestamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Column(
        children: [
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
          const Divider(
          ),
          Column(
            children:[Text('Previously asked Questions',textAlign: TextAlign.center)]
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getCommunityPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No questions posted yet.'));
                }
                final posts = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;
                    final postId = posts[index].id;
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post['question'] ?? '',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            if (post['imageUrl'] != null)
                              Image.network(
                                post['imageUrl'],
                                width: 100,
                                height: 100,
                              ),
                            const SizedBox(height: 8.0),
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
                            CommentSection(
                              postId: postId,
                              addComment: _addComment,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to add comment
  Future<void> _addComment(String postId, String comment) async {
    try {
      await FirebaseFirestore.instance.collection('community').doc(postId).update({
        'comments': FieldValue.arrayUnion([comment])
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}

class CommentSection extends StatefulWidget {
  final String postId;
  final Function(String, String) addComment;

  CommentSection({required this.postId, required this.addComment});

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
            widget.addComment(widget.postId, _commentController.text);
            _commentController.clear();
          },
        ),
      ],
    );
  }
}
