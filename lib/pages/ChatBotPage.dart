import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text("AI ChatBot")),
        body: const ChatScreen(),
      ),
    );
  }
}

// Chat Screen Widget
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              var message = chatProvider.messages[index];
              bool isUser = message['isUser'];
              bool hasImage = message.containsKey('image');

              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasImage) // Show image if present
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Image.file(
                            File(message['image']),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Text(
                        message['text'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (chatProvider.isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => chatProvider.pickAndSendImage(),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: "Type a message..."),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    chatProvider.sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Chat Provider (Handles API calls)
class ChatProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  final String apiKey = "AIzaSyCVUABmizXxpqJaX23qSKLnfz4QU8rJCM4";  // Replace with your API key
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  Future<void> sendMessage(String userMessage) async {
    _messages.add({'text': userMessage, 'isUser': true});
    _isLoading = true;
    notifyListeners();

    try {
      var response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userMessage}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var botMessage = responseData['candidates'][0]['content']['parts'][0]['text'] ?? "I couldn't understand.";

        _messages.add({'text': formatResponse(botMessage), 'isUser': false});
      } else {
        _messages.add({'text': "Error: Unable to fetch response", 'isUser': false});
      }
    } catch (e) {
      _messages.add({'text': "Error: $e", 'isUser': false});
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickAndSendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String base64Image = base64Encode(await imageFile.readAsBytes());

      _messages.add({'text': "Sent an image", 'isUser': true, 'image': pickedFile.path});
      _isLoading = true;
      notifyListeners();

      try {
        var response = await http.post(
          Uri.parse("$apiUrl?key=$apiKey"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "parts": [
                  {
                    "inlineData": {
                      "mimeType": "image/jpeg",
                      "data": base64Image
                    }
                  }
                ]
              }
            ]
          }),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          var botMessage = responseData['candidates'][0]['content']['parts'][0]['text'] ?? "I couldn't understand the image.";

          _messages.add({'text': formatResponse(botMessage), 'isUser': false});
        } else {
          _messages.add({'text': "Error: Unable to fetch response", 'isUser': false});
        }
      } catch (e) {
        _messages.add({'text': "Error: $e", 'isUser': false});
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  String formatResponse(String response) {
    // Basic formatting for better readability
    response = response.replaceAll("•", "\n•");  // Bullet points in new line
    response = response.replaceAll(RegExp(r'(?<!\n)\n(?!\n)'), "\n\n");  // Double new lines for better spacing
    return response;
  }
}
