import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage for navigation

class LoginSignupPage extends StatefulWidget {
  final String userType;

  LoginSignupPage({required this.userType});

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Controllers to manage the text in the fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Toggle between Login and Signup forms and clear all fields
  void toggleFormType() {
    setState(() {
      isLogin = !isLogin;
      // Clear the text fields when switching between login and signup
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  void submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (isLogin) {
        // Navigate to HomePage after clicking login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Automatically switch to login page after signup
        toggleFormType(); // Switch back to login form
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userType} ${isLogin ? 'Login' : 'Sign Up'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value ?? '';
                },
              ),
              if (!isLogin)
                SizedBox(height: 10),
              if (!isLogin)
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    // Check if passwords match
                    if (value == null || value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmPassword = value ?? '';
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text(isLogin ? 'Login' : 'Sign Up'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: toggleFormType,
                child: Text(isLogin
                    ? "Don't have an account? Sign Up"
                    : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}