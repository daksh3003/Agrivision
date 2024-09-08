import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/seller/seller_home.dart';
import 'package:agriplant/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String userType; // User type (Farmer/Seller)

  const LoginPage({Key? key, required this.userType}) : super(key: key);

  @override
  _SampleLoginState createState() => _SampleLoginState();
}

class _SampleLoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables to toggle password visibility
  bool _passwordVisible = false;

  // Variables to track validation status
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  // Regular expression for email validation
  final emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');

  // Real-time validation for the Email field
  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = emailRegExp.hasMatch(value);
    });
  }

  // Real-time validation for the Password field
  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 6;
    });
  }

  void submitForm() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    print('Submitting form with email: $email and password: $password');

    if (_formKey.currentState?.validate() ?? false) {
      try {

        QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: email).get();
        if(userQuery.docs.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found')),
          );
          return;
        }
        DocumentSnapshot userDoc = userQuery.docs.first;

        String userType = userDoc.get('userType');

        if(userType!=widget.userType){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This email is associated with $userType. Please use the correct email to login'))
          );
          return;
        }

        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('User signed in: ${userCredential.user}');

        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if(widget.userType == "Farmer"){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
          else if(widget.userType == "Seller"){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SellerHome(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (ex) {
        print('FirebaseAuthException: ${ex.code}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${ex.message}')),
        );
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unknown error occurred')),
        );
      }
    } else {
      print('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.green;

    return GestureDetector(
      onTap: () {
        // Unfocus the current TextField when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background with solid primary color
            Container(
              height: double.infinity,
              width: double.infinity,
              color: primaryColor, // Use primary color from theme
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Hello\nSign in!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Email Field with Real-Time Validation and Validator
                          TextFormField(
                            controller: _emailController,
                            onChanged: _validateEmail, // Real-time validation
                            decoration: InputDecoration(
                              suffixIcon: _isEmailValid
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Set label text color to primary color
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || !emailRegExp.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Password Field with Real-Time Validation and Validator
                          TextFormField(
                            controller: _passwordController,
                            onChanged: _validatePassword, // Real-time validation
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Set label text color to primary color
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black, // Set the forgot password link color to primary color
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                          // Sign In Button
                          GestureDetector(
                            onTap: submitForm,
                            child: Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: primaryColor, // Set the button color to primary color
                              ),
                              child: const Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 150),
                          // Sign Up Prompt
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to Sign Up Page
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(userType: widget.userType),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
