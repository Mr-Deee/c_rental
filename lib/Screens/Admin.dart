import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AddVehicle.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final locates = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size; //check the size of device
    final arg = (ModalRoute.of(context)?.settings.arguments ??
        <dynamic, dynamic>{}) as Map;
    return Scaffold(
        appBar: AppBar(
          title: Text("Admin"),
          actions: [
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Sign Out'),
                      backgroundColor: Colors.white,
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text('Are you certain you want to Sign Out?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            print('yes');
                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/SignIn", (route) => false);
                            // Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Column(children: [
          SizedBox(
            height: 154,
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Card(
                elevation: 8,
                color: Colors.black,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 28.0, left: 7, right: 13),
                          child: Image.asset(
                            "assets/images/audi.png",
                            width: 53,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                            "Benji's Admin",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [],
                    )
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => NewVehicle()),
                            (Route<dynamic> route) => true);
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.black,
                        shadowColor: Colors.blueAccent,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Image.asset("assets/images/audi.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 50, right: 30),
                              child: Text('Add New Vehicle',
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => NewVehicle()),
                            (Route<dynamic> route) => true);
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.white,
                        shadowColor: Colors.white70,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: Image.asset("assets/images/audi.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 50, right: 30),
                              child: Text('Check Rentals',
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ]));
  }
}
