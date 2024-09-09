import 'dart:io';
import 'package:agriplant/pages/detection_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceDetailPage extends StatefulWidget {
  final String serviceName;
  final String detectedDisease;

  const ServiceDetailPage({
    super.key,
    required this.serviceName,
    required this.detectedDisease,
  });

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  File? _image;
  String? _prediction;
  bool _isLoading = false; // Track loading state

  // List of server URLs corresponding to different services
  final List<String> serverUrls = [
    'http://192.168.191.101:8000/predict',  // URL for Cotton service
    'http://192.168.191.101:8080/predict',   // URL for Wheat service
    'http://192.168.191.101:8080/predict',    // URL for Corn service
    // Add more URLs as needed
  ];

  // Function to get the server URL based on serviceName
  String get serverUrl {
    switch (widget.serviceName) {
      case 'Cotton':
        return serverUrls[0];
      case 'Wheat':
        return serverUrls[1];
      case 'Corn':
        return serverUrls[2];
      default:
        throw Exception('Service not supported');
    }
  }

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
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> responseJson = json.decode(responseData.body);
        setState(() {
          _prediction = responseJson['prediction'];
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
        _showError('Failed to upload image');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  // Function to show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
                    onPressed: _isLoading ? null : () {
                      if (_image != null) {
                        _uploadImage(_image!);
                      }
                    },
                    icon: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.upload),
                    label: Text(_isLoading ? 'Processing...' : 'Detect'),
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
