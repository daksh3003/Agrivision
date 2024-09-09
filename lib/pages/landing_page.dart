import 'package:flutter/material.dart';
import 'login_signup_page.dart';

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
    final primaryColor = Theme.of(context).primaryColor; // Get the primary color

    return Scaffold(
      appBar: AppBar(
        title: Text('AgriVision'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bringing the text closer to the top with more space below
            SizedBox(height: 10), // Decrease this value to bring text higher
            // Centered text "Who are you?"
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Who are you?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 60), // Increase space between text and cards
            GestureDetector(
              onTap: () {
                navigateToLogin('Farmer');
              },
              child: Card(
                elevation: 10, // Add elevation to the card
                color: Colors.green, // Use primary color from the theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Optional: Add rounded corners
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Increase width to 85% of screen width
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.agriculture, size: 80, color: Colors.white), // Adjusted to fit the card color
                      SizedBox(height: 10),
                      Text('I am a Farmer',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            GestureDetector(
              onTap: () {
                navigateToLogin('Seller');
              },
              child: Card(
                elevation: 10, // Add elevation to the card
                color: Colors.orange, // Use primary color from the theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Optional: Add rounded corners
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Increase width to 85% of screen width
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.store, size: 80, color: Colors.white), // Adjusted to fit the card color
                      SizedBox(height: 10),
                      Text('I am a Seller',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
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
