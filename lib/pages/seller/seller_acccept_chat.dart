import 'package:flutter/material.dart';

class SellerSidePage extends StatefulWidget {
  @override
  _SellerSidePageState createState() => _SellerSidePageState();
}

class _SellerSidePageState extends State<SellerSidePage> {
  final List<Map<String, dynamic>> orders = [
    {"farmerName": "Farmer A", "order": "Order 1", "accepted": false, "profilePic": "https://media.istockphoto.com/id/1412751704/photo/female-farmer-is-holding-a-digital-tablet-in-a-farm-field-smart-farming.jpg?s=612x612&w=0&k=20&c=ip06mZA-0nloTCIeoxhabfsoTedXen14zRh8l9gLVnU="},
    {"farmerName": "Farmer B", "order": "Order 2", "accepted": false, "profilePic": "https://plus.unsplash.com/premium_photo-1682092016074-b136e1acb26e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW5kaWFuJTIwZmFybWVyfGVufDB8fDB8fHww"},
  ];

  void _acceptOrder(int index) {
    setState(() {
      orders[index]['accepted'] = true;
    });
  }

  void _openChat(String farmerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(farmerName: farmerName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy And Chat'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(order['profilePic']),
                radius: 25,
              ),
              title: Text(
                '${order['farmerName']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${order['order']}'),
              trailing: order['accepted']
                  ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
                onPressed: () => _openChat(order['farmerName']),
                icon: Icon(Icons.chat),
                label: Text('Chat'),
              )
                  : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
                onPressed: () => _acceptOrder(index),
                icon: Icon(Icons.check),
                label: Text('Accept'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String farmerName;

  ChatPage({required this.farmerName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    setState(() {
      messages.add({
        'message': _messageController.text,
        'isSender': true,
      });
      _messageController.clear();
    });
  }

  void _receiveMessage(String message) {
    setState(() {
      messages.add({
        'message': message,
        'isSender': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.farmerName}'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                  msg['isSender'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: msg['isSender'] ? Colors.green.shade100 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg['message'],
                      style: TextStyle(
                        color: msg['isSender'] ? Colors.green.shade900 : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.green.shade700),
                  onPressed: () {
                    // Handle sending an image or taking a photo
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green.shade700),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
