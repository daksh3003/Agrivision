import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetectionPage extends StatelessWidget {
  final String serviceName; // The name of the service/crop selected

  DetectionPage({required this.serviceName});

  // Dummy data for demonstration purposes
  final String diseaseResult = "Late Blight";
  final List<String> solutions = [
    "Use fungicide to control the disease.",
    "Remove infected plants from the field.",
    "Ensure good air circulation around the crops.",
    "Avoid overhead irrigation."
  ];
  final String youtubeUrl = "https://www.youtube.com/watch?v=G8yKFVPOD-4"; // Dummy YouTube URL

  @override
  Widget build(BuildContext context) {
    // Extract video ID from the YouTube URL
    String videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('$serviceName Detection Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detected Disease for $serviceName:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                diseaseResult,
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              SizedBox(height: 20),
              Text(
                'Possible Solutions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...solutions.map((solution) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "- $solution",
                  style: TextStyle(fontSize: 16),
                ),
              )),
              SizedBox(height: 20),
              Text(
                'Watch the video for more solutions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
