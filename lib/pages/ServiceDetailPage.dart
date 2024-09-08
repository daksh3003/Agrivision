import 'dart:io';
import 'package:agriplant/data/services.dart';
import 'package:agriplant/pages/detection_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceDetailPage extends StatefulWidget {
  final String serviceName;
  final String detectedDisease;

  const ServiceDetailPage({super.key, required this.serviceName, required this.detectedDisease});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  File? _image;
  String? _prediction;

  // The address of the Flask server
  final String serverUrl = 'http://192.168.191.101:8080/predict';

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to capture an image from the camera
  Future<void> _captureImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload the image to the Flask server
  Future<void> _uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var res = await request.send();
    if (res.statusCode == 200) {
      final response = await http.Response.fromStream(res);
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _prediction = responseData['prediction'];
      });
      // Pass the prediction to the DetectionPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetectionPage(
            serviceName: widget.serviceName,
            detectedDisease: _prediction ?? '',  // Pass the detected disease
          ),
        ),
      );
    } else {
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceName),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the picked/captured image
              _image != null
                  ? Image.file(
                _image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : const Text(
                'No image selected',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Display prediction result
              _prediction != null
                  ? Text(
                'Prediction: $_prediction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
                  : const SizedBox(),

              // Button to upload an image from the device
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo),
                  label: const Text('Upload from Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
              ),

              // Button to open the camera
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton.icon(
                  onPressed: _captureImageFromCamera,
                  icon: const Icon(Icons.camera),
                  label: const Text('Open Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                ),
              ),

              // Button to upload the selected image to the server
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_image != null) {
                        _uploadImage(_image!);
                      }
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Detect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
