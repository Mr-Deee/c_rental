import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'IconVehicles.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? userEmail = "", userId = "";
  String firstName = "", lastName = "";
  List<Vehicle> vehicles = [];
  String selectedLogo = "";
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<LogoData> logos = [
    LogoData("Bmw", "assets/images/bmw.png"),
    LogoData("Toyota", "assets/images/toyota.png"),
    LogoData("Escalade", "assets/images/CADILAC.png"),
    LogoData("Hyundai", "assets/images/hyundai.png"),
    //   LogoData("Nissan", "assets/nissan_logo.png"),
    //   LogoData("Hyundai", "assets/hyundai_logo.png"),
    //   LogoData("Ford", "assets/ford_logo.png"),
    //   LogoData("Suzuki", "assets/suzuki_logo.png"),
    //   LogoData("Honda", "assets/honda_logo.png"),
    // ];
  ];

  @override
  void initState() {
    doSomeAsyncStuff();
    _fetchFeaturedVehicles();

    super.initState();
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> _fetchFeaturedVehicles() async {
    databaseReference
        .child('vehicles')
        .orderByChild('status')
        .equalTo('featured')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        setState(() {
          vehicles.add(Vehicle(
            name: value['model_name'],
            imageUrl: value['VehicleImages'],
            speed: double.parse(value['speed'].toString()),
            pricePerDay: double.parse(value['price'].toString()),
          ));
        });
      });
    });
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
        });
        print('Document data: ${documentSnapshot.get("lastName")}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              new UserAccountsDrawerHeader(
                accountName: Text(
                  lastName,
                  style: TextStyle(color: Colors.red),
                ),
                accountEmail: Text(
                  userEmail!,
                  style: TextStyle(color: Colors.red),
                ),
                decoration: BoxDecoration(color: Colors.white),
                currentAccountPicture: new CircleAvatar(
                  radius: 50.0,
                  backgroundColor: const Color(0xFF778899),
                  backgroundImage:
                      NetworkImage("http://tineye.com/images/widgets/mona.jpg"),
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Benji's"),
          actions: [
            TextButton(
              onPressed: signOutFromGoogle,
              child: Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            )
          ],
        ),
        body: Container(
          height: screenHeight,
          child: Column(
              children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 18.0),
                  child: Text(
                    "Featured",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showRentDialog(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // Optional: add border radius for rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                // shadow color
                                spreadRadius: 2,
                                // spread radius
                                blurRadius: 12,
                                // blur radius
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        height: 200, // Adjust height as needed
                        child: PageView.builder(
                          itemCount: vehicles[index].imageUrl.length,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      vehicles[index].imageUrl[pageIndex]),
                                  // Use fetched images from the list
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(vehicles[index].name),
                                    subtitle: Text(
                                        'Speed: ${vehicles[index].speed} mph | Price Per Day: \$${vehicles[index].pricePerDay}'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              height: 222,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: logos
                        .map((logo) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLogo = logo.name;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => VehiclePage(
                                    vehicleName: selectedLogo,
                                  ),
                                  ));
                                });
                              },
                              child: Image.asset(
                                logo.imageUrl,
                                width: 50,
                                height: 50,
                              ),
                            ))
                        .toList(),
                  ),

                ],
              ),
            )
          ]),
        ));
  }

  void _showRentDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rent Vehicle'),
          content: Text('Do you want to rent ${vehicles[index].name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Add your code here to rent the vehicle
                Navigator.of(context).pop();
              },
              child: Text('Rent'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginScreen()), (_) => false);
  }

  void fetchVehicles(String logoName) {
    _database
        .child('vehicles')
        .orderByChild('model_name')
        .equalTo(logoName)
        .once()
        .then((DatabaseEvent event) {
      vehicles.clear();
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        List<String> imageUrls = [];
        for (var imageUrl in value['VehicleImages']) {
          imageUrls.add(imageUrl);
        }
        vehicles.add(Vehicle2(value['model_name'], imageUrls) as Vehicle);
      });
      setState(() {});
    }).catchError((error) {
      print("Failed to fetch vehicles: $error");
    });
  }
}

class Vehicle {
  final String name;
  final imageUrl;
  final double speed;
  final double pricePerDay;

  Vehicle({
    required this.name,
    required this.imageUrl,
    required this.speed,
    required this.pricePerDay,
  });
}

class LogoData {
  final String name;
  final String imageUrl;

  LogoData(this.name, this.imageUrl);
}

class Vehicle2 {
  final String modelName;
  final List<String> imageUrls;

  Vehicle2(this.modelName, this.imageUrls);
}
