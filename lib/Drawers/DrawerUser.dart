import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Screens/Clients/LoginScreen.dart';
import '../Screens/Clients/myreservation.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0047AB), Color(0xFF186CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            child: Row(children: [
              SizedBox(height: 34,),

              Container(
                margin: EdgeInsets.only(
                    top: heightDevice * 0.05, left: widthDevice * 0.06),
                child: SingleChildScrollView(
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
                            Row(
                              children: [
                                Text(
                                  "${userprovider!.firstname}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),Text(
                                  userprovider.lastname.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                  
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                userprovider.email.toString(),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                  
                      Container(
                        margin: EdgeInsets.only(top: heightDevice * 0.11),
                        child: SizedBox(
                  
                          child: TextButton(
                            onPressed: signOutFromGoogle,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                  
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),




            ]),
          ),
          Container(
            child: Column(children: [
              Column(children: [


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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RentedContainersPage()));
                  },
                ),

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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.contact_phone, color: Colors.blue.shade900),
                              const SizedBox(width: 10),
                              const Text(
                                'Contact Us',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.email, color: Colors.blue.shade900),
                                title: const Text('Email'),
                                subtitle: const Text('benjicab3@gmail.com'),
                              ),
                              Divider(color: Colors.blue.shade100),
                              ListTile(
                                leading: Icon(Icons.phone, color: Colors.blue.shade900),
                                title: const Text('Phone'),
                                subtitle: const Text('0302528381'),
                              ),
                              Divider(color: Colors.blue.shade100),
                              ListTile(
                                leading: Icon(Icons.location_on, color: Colors.blue.shade900),
                                title: const Text('Address'),
                                subtitle: const Text('Ablorh-Adjei community centre Old, Ashongman-Abokobi Rd, Accra'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('About us'),
                  leading: Icon(Icons.info, color: Colors.black),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ]),

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
void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, size: 50, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  'Our Mission, Vision & Core Values',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'We aim to become the industry leader in car rentals in Ghana by consistently innovating and providing top-notch customer experiences. Below are our core values:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildHoverCardWithPopup(
                      context: context,
                      icon: Icons.lightbulb_outline,
                      title: 'Innovation',
                      description: 'We constantly innovate to meet customer needs efficiently.',
                    ),
                    _buildHoverCardWithPopup(
                      context: context,
                      icon: Icons.handshake_outlined,
                      title: 'Customer Focus',
                      description: 'Customer satisfaction is at the heart of everything we do.',
                    ),
                    _buildHoverCardWithPopup(
                      context: context,
                      icon: Icons.attach_money,
                      title: 'Affordability',
                      description: 'Affordable solutions tailored to everyone’s needs.',
                    ),
                    _buildHoverCardWithPopup(
                      context: context,
                      icon: Icons.emoji_events_outlined,
                      title: 'Growth',
                      description: 'We strive for growth to lead the rental industry in Ghana.',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
Widget _buildHoverCardWithPopup({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String description,
}) {
  return MouseRegion(
    onEnter: (event) {
//      _showPopup(context, title, description);
    },
    onExit: (event) {
      Navigator.pop(context);
    },
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
