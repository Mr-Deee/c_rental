import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<LogoData> logos = [
    LogoData("Toyota", "assets/images/toyota_logo.png"),
    LogoData("BMW", "assets/images/bmw_logo.png"),
    LogoData("Benz", "assets/imaages/maserati.png"),
    LogoData("Nissan", "assets/nissan_logo.png"),
    LogoData("Hyundai", "assets/hyundai_logo.png"),
    LogoData("Ford", "assets/ford_logo.png"),
    LogoData("Suzuki", "assets/suzuki_logo.png"),
    LogoData("Honda", "assets/honda_logo.png"),
  ];

  @override
  void initState() {
    doSomeAsyncStuff();
    _fetchFeaturedVehicles();

    super.initState();
  }
  final databaseReference = FirebaseDatabase.instance.reference();



  Future<void> _fetchFeaturedVehicles() async {
    databaseReference.child('vehicles').orderByChild('status').equalTo('featured').once().then((DatabaseEvent event) {
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
        title: Text('Hello'),
        actions: [   TextButton(
          onPressed: signOutFromGoogle,
          child: Text(
            'Log out',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        )],
      ),
      body: Center(
          child: Column(children: [
        Text(userEmail!),
        SizedBox(height: 34,),
        Expanded(
          child: ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showRentDialog(index);
                },
                child: Container(
                  height: 200, // Adjust height as needed
                  child: PageView.builder(
                    itemCount: vehicles[index].imageUrl.length,
                    itemBuilder: (BuildContext context, int pageIndex) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(vehicles[index].imageUrl[pageIndex]), // Use fetched images from the list
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(vehicles[index].name),
                              subtitle: Text('Speed: ${vehicles[index].speed} mph | Price Per Day: \$${vehicles[index].pricePerDay}'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              );
            },
          ),
        ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: logos
                      .map((logo) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLogo = logo.name;
                        fetchVehicles(selectedLogo);
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
                if (selectedLogo.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(vehicles[index].name),
                          children: vehicles[index]
                              .imageUrl
                              .map((imageUrl) => Image.network(imageUrl))
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ],
      ])),
    );
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
        },);}
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginScreen()), (_) => false);
  }

  void fetchVehicles(String logoName) {
    _database.child('vehicles').orderByChild('model_name').equalTo(logoName).once().then((DatabaseEvent event) {
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
  final  imageUrl;
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


