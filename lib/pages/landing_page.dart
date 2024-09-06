import 'package:flutter/material.dart';
import 'login_signup_page.dart'; // Import the login/signup page

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void navigateToLogin(String selectedUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginSignupPage(userType: selectedUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Crop Disease Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                navigateToLogin('Farmer');
              },
              child: Card(
                color: Colors.green[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.agriculture, size: 80, color: Colors.green),
                      SizedBox(height: 10),
                      Text('I am a Farmer', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                navigateToLogin('Seller');
              },
              child: Card(
                color: Colors.orange[200],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.store, size: 80, color: Colors.orange),
                      SizedBox(height: 10),
                      Text('I am a Seller', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
