import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/constants.dart';
import '../main.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _firstnameController = TextEditingController();
  var fullPhoneNumber = TextEditingController();
  var _lastnameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPwdController = TextEditingController();

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _confirmPwdController = new TextEditingController();

    super.initState();
  }

  String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Email format is invalid';
    } else {
      return "";
    }
  }

  String? pwdValidator(String? value) {
    if (value!.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Background Container
            Container(
              height: heightDevice,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            // Logo Positioned
            Positioned(
              top: heightDevice * 0.10,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo1.png",
                  height: 88,
                ),
              ),
            ),
            // Animation Positioned
            Positioned(
              top: heightDevice * 0.18, // Adjust based on height spacing
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/car-animation.json',
                    width: 257,
                  ),
                ],
              ),
            ),
            // Form Positioned
            Positioned(
              top: heightDevice * 0.35, // Adjust spacing for even alignment
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          SizedBox(height: 17),
                          _buildTextField(
                            controller: _firstnameController,
                            label: "First Name",
                            icon: Icons.person, widthDevice: widthDevice/0.98
                          ),
                          SizedBox(height: 17),
                          _buildTextField(
                            controller: _lastnameController,
                            label: "Last Name",
                            icon: Icons.person, widthDevice: widthDevice/0.98,
                          ),
                          SizedBox(height: 17),
                          _buildTextField(
                            controller: _emailController,
                            label: "Email",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress, widthDevice: widthDevice/0.98,
                          ),
                          SizedBox(height: 17),
                          _buildPasswordField(
                            controller: _passwordController, 
                            widthDevice: widthDevice/0.98,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: widthDevice * 0.8,
                            height: heightDevice * 0.09,
                            child: TextButton(
                              onPressed: () async {
                                registerNewUser(context);
                              },
                              child: Text(
                                'Sign Up',
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
                          SizedBox(height: heightDevice * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'RobotoMono',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontFamily: 'RobotoMono',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  void firebaseRegistration() async {
    if (_confirmPwdController.text == _passwordController.text) {
      _registerFormKey.currentState!.validate();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(value.user!.uid)
              .set({
            "email": _emailController.text,
            "password": _passwordController.text,
          });
        }).then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (_) => false));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      AlertDialog alert = AlertDialog(
        title: Text("Passwords doesn't match"),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],
        content: Text("It is the body of the alert Dialog"),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }

  User? firebaseUser;
  User? currentfirebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerNewUser(BuildContext context) async {
    // String fullPhoneNumber = '$selectedCountryCode${phonecontroller.text.trim()
    //     .toString()}';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6.0,
                            ),
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            SizedBox(
                              width: 26.0,
                            ),
                            Text("Signing up,please wait...")
                          ],
                        ),
                      ))));
        });

    firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToast("Error" + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) // user created

    {
      //save use into to database

      Map userDataMap = {
        "email": _emailController.text.trim().toString(),
        "FirstName": _firstnameController.text.trim().toString(),
        "LastName": _lastnameController.text.trim().toString(),
        // "phoneNumber": fullPhoneNumber,
        "Password": _passwordController.text.trim().toString(),
      };
      Clientsdb.child(firebaseUser!.uid).set(userDataMap);
      // Admin.child(firebaseUser!.uid).set(userDataMap);

      currentfirebaseUser = firebaseUser;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return login();
      //   }),
      // );      // Navigator.pop(context);
      // error occured - display error
      displayToast("user has not been created", context);
    }
  }
}


// Helper Method for TextFields
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required double widthDevice, // Add widthDevice as a required parameter
  TextInputType keyboardType = TextInputType.text,
}) {


  return Container(
     width: widthDevice * 0.8,
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14.0),
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xff98e6e6), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(icon, color: Colors.grey[600]),
      ),
    ),
  );
}

// Helper Method for Password Field
Widget _buildPasswordField({required TextEditingController controller,  required double widthDevice, // Add widthDevice as a required parameter
}) {
  return _buildTextField(
    controller: controller,
    label: "Password",
    icon: Icons.password, widthDevice: widthDevice,
    
  );
}


displayToast(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
