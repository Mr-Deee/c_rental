import 'package:c_rental/Screens/Admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../Constants/constants.dart';
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: heightDevice * 0.10),
                child: Text(
                  "",
                  style: TextStyle(
                    color: Color(0XFF091424),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
              Lottie.asset('assets/animations/car-animation.json', height: heightDevice * 0.25),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1.3,
                        color:Colors.blue
                    )
                  ]
                ),
                child: Form(
                  key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Column(
                        children: [
                          _buildEmailField(widthDevice),
                          _buildPasswordField(widthDevice),
                          _buildLoginButton(widthDevice, heightDevice),
                          _buildSignUpPrompt(),
                        ],
                      ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(double widthDevice) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "Email Address",
          hintText: "Enter your email",
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide(
              color: Color(0xff98e6e6), // Border color when enabled
              width: 1.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorStyle: TextStyle(color: Colors.redAccent),
        ),
        validator: _emailValidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _buildPasswordField(double widthDevice) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Password",
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide(
              color: Color(0xff98e6e6), // Border color when enabled
              width: 1.0, // Border width
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorStyle: TextStyle(color: Colors.redAccent),
        ),
        validator: _pwdValidator,
        obscureText: true,
      ),
    );
  }

  Widget _buildLoginButton(double widthDevice, double heightDevice) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: SizedBox(
        width: widthDevice * 0.8,
        height: heightDevice * 0.09,
        child: TextButton(
          onPressed: () {
            _loginAndAuthenticateUser(context);
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don't have an account? ",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text(
              "Register",
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value == null || !regex.hasMatch(value)) {
      return 'Email format is invalid';
    }
    return null;
  }

  String? _pwdValidator(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be longer than 8 characters';
    }
    return null;
  }

  void _loginAndAuthenticateUser(BuildContext context) async {
    if (!_loginFormKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                  SizedBox(width: 26.0),
                  Text("Logging In, please wait"),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      const String adminEmail = 'admin@gmail.com';
      if (_emailController.text.trim() == adminEmail) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Admin()));
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
      displayToast("Logged in successfully", context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayToast("Error: ${e.message}", context);
    }
  }
}
