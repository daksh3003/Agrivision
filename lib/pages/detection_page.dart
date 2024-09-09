import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetectionPage extends StatefulWidget {
  final String serviceName; // The name of the service/crop selected
  final String detectedDisease; // The detected disease passed from the ServiceDetailPage

  DetectionPage({required this.serviceName, required this.detectedDisease});

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  String diseaseResult = "";
  String solution = "";
  String youtubeUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPredictionData();
  }

  Future<void> fetchPredictionData() async {
    try {
      final diseaseSnapshot = await FirebaseFirestore.instance
          .collection('predictions')
          .where('disease', isEqualTo: widget.detectedDisease) // Use the detected disease directly
          .limit(1)
          .get();

      if (diseaseSnapshot.docs.isNotEmpty) {
        final diseaseData = diseaseSnapshot.docs.first.data();
        solution = diseaseData['solution'] ?? "";
        youtubeUrl = diseaseData['ytlink'] ?? "";
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract video ID from the YouTube URL
    String videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${widget.serviceName} Detection Result'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detected Disease for ${widget.serviceName}:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.detectedDisease,
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              SizedBox(height: 20),
              Text(
                'Possible Solutions:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  solution,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Watch the video for more solutions:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              youtubeUrl.isNotEmpty
                  ? YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.redAccent,
              )
                  : Text('No video available.'),
            ],
          ),
        ),
      ),
    );
  }
}
