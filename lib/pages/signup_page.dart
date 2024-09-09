import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  final String userType;
  const SignUpPage({Key? key, required this.userType}) : super(key: key);

  @override
  _SampleSignupState createState() => _SampleSignupState();
}

class _SampleSignupState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Variables to toggle password visibility
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Variables to track validation status
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;

  // Regular expression for email validation
  final emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');

  // Regular expression for Phone Number validation
  final phoneRegExp = RegExp(r'^[1-9]\d{9}$');


  // Real-time validation for the Name field
  void _validateName(String value) {
    setState(() {
      _isNameValid = value.isNotEmpty;
    });
  }

  // Real-time validation for the Email field
  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = emailRegExp.hasMatch(value);
    });
  }

  // Real-time validation for the Phone Number field
  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = phoneRegExp.hasMatch(value);
    });
  }

  // Function to handle form submission
  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: password,
        );

        if (userCredential.user != null) {
          // Store additional user information in Firestore
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'userType': widget.userType,
          });

          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(userType: widget.userType),
            ),
          );
        }
      } on FirebaseAuthException catch (ex) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${ex.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unknown error occurred')),
        );
      }
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
            Container(
              height: double.infinity,
              width: double.infinity,
              color: primaryColor,
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
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
                          // Name Field with Real-Time Validation and Validator
                          TextFormField(
                            controller: _nameController,
                            onChanged: _validateName, // Real-time validation
                            decoration: InputDecoration(
                              suffixIcon: _isNameValid
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name cannot be blank';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
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
                                color: Colors.black,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty || !emailRegExp.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Name Field with Real-Time Validation and Validator
                          TextFormField(
                            controller: _phoneController,
                            onChanged: _validatePhone, // Real-time validation
                            decoration: InputDecoration(
                              suffixIcon: _isPhoneValid
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Password Field with Visibility Toggle and Validator
                          TextFormField(
                            controller: _passwordController,
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
                                color: Colors.black,
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
                          const SizedBox(height: 10),
                          // Confirm Password Field with Visibility Toggle and Validator
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible = !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            obscureText: !_confirmPasswordVisible,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 70),
                          GestureDetector(
                            onTap: submitForm,
                            child: Container(
                              height: 55,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: primaryColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(userType: widget.userType),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Log in",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
