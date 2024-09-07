import 'package:agriplant/pages/home_page.dart';
import 'package:agriplant/pages/signup_page.dart';
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

  // Function to handle form submission
  void submitForm() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_formKey.currentState?.validate() ?? false) {
      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        if(userCredential.user !=null){
          
          Navigator.popUntil(context,(route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      }on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${ex.message}')),
        );
      }catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unknown error occurred')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the primary color from the theme
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.check, color: Colors.grey),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Set label text color to primary color
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Set label text color to primary color
                          ),
                        ),
                        obscureText: true,
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
        ],
      ),
    );
  }
}
