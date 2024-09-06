import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignUpPage extends StatefulWidget {
  final String userType;

  SignUpPage({required this.userType});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

 TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
   TextEditingController _confirmPasswordController = TextEditingController();
  void testFirebaseConnection() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Firebase is working!');
    } catch (e) {
      print('Error connecting to Firebase: $e');
    }
  }

  void createAccount() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if(email == "" || password == "" || confirmPassword == ""){
      print("enter all the values");
    }
    else if(password != confirmPassword){
      print("passwords do not match");
    }
    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        if(userCredential.user != null){
          final uid = userCredential.user!.uid;
          final firestore = FirebaseFirestore.instance;
          await firestore.collection('users').doc(uid).set({
            'name': userCredential.user!.email,
            'userType': widget.userType,
          });
          Navigator.pop(context);
        }
      }
      on FirebaseAuthException catch(ex){
        print(ex.code.toString());
      }
    }
  }

  // void submitForm() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Navigate back to LoginPage after signup
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage(userType: widget.userType)),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userType} Sign Up'),
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
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: createAccount,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate back to the Login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(userType: widget.userType)),
                  );
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
