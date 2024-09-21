import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Screens/LoginScreen.dart';
import '../Screens/ProfilUserScreen.dart';
import '../Screens/ReportScreen.dart';
import '../Users.dart';


class DrawerUser extends StatefulWidget {
  const DrawerUser({Key? key}) : super(key: key);

  @override
  _DrawerUserState createState() => _DrawerUserState();
}

class _DrawerUserState extends State<DrawerUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? userEmail = "", userId = "";
  String firstName = "H", lastName = "", gender = "", phoneNumber = "";

  @override
  void initState() {
    doSomeAsyncStuff();

    super.initState();
  }

  Future<void> doSomeAsyncStuff() async {
    User? user = _auth.currentUser;
    setState(() {
      userEmail = user!.email;
      userId = user.uid;
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          lastName = documentSnapshot.get("lastName");
          firstName = documentSnapshot.get("firstName");
          gender = documentSnapshot.get("gender");
          phoneNumber = documentSnapshot.get("phoneNumber");
        });
        print('Document data: ${documentSnapshot.get("lastName")}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;

    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: heightDevice * 0.3,
            color: Color(0xFF0047AB),
            child: Column(children: [
              SizedBox(height: 34,),

              Container(
                margin: EdgeInsets.only(
                    top: heightDevice * 0.05, left: widthDevice * 0.06),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor:Colors.grey,
                        radius: 34,
                        child: Text(userprovider!.firstname??[0].toString()??"",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: heightDevice * 0.015, left: widthDevice * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userprovider!.firstname}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            userprovider.lastname.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Text(
                userprovider.email.toString(),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ),
          Container(
            child: Column(children: [
              Column(children: [
                // ListTile(
                //   title: const Text('All Cars'),
                //   leading: Icon(Icons.car_rental, color: Colors.black),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => VehicleScreen()));
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.black),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilUserScreen(
                                // userEmail,
                                // userId,
                                // firstName,
                                // lastName,
                                // phoneNumber,
                                // gender
                         )));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment, color: Colors.black),
                  title: const Text('My Reservations'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             MyReservationsScreen(userId)));
                  },
                ),
                // ListTile(
                //   leading:
                //       Icon(Icons.favorite_rounded, color: Color(0XFFF01E1F)),
                //   title: const Text('Favourites'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => FavoriteScreen()));
                //   },
                // ),
                ListTile(
                  title: const Text('Report'),
                  leading: Icon(Icons.report, color: Colors.black),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Contact us'),
                  leading: Icon(Icons.quick_contacts_mail, color: Colors.black),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ]),
              Container(
                margin: EdgeInsets.only(top: heightDevice * 0.1),
                child: SizedBox(
                  width: widthDevice * 0.25,
                  child: TextButton(
                    onPressed: signOutFromGoogle,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        Text(
                          "Log Out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginScreen()), (_) => false);
  }
}
