import 'package:agriplant/pages/login_page.dart';
import 'package:agriplant/pages/signup_page.dart';
import 'package:flutter/material.dart';


class LoginSignupPage extends StatelessWidget {
  final String userType;

  const LoginSignupPage({Key? key, required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.green, // Solid color background
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              // Use the logo image from assets
              child: Image(image: AssetImage('assets/Agrivision_no_bg.png'), height: 100), // Add height if needed
            ),
            const SizedBox(height: 100),
            const Text(
              'Welcome !',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(userType: userType),
                  ),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(userType: userType),
                  ),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
