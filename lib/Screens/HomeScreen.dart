import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'IconVehicles.dart';
import 'LoginScreen.dart';
import 'VehicleDetails.dart';

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
  List<Vehicle> vehicles1 = [];
  List<affordablevehicle> affordablevehicles = [];
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
    _fetchAffordableVehicles();
    _fetchVehicles();
    super.initState();
  }

  void _fetchVehicles() async {
    DatabaseEvent event = (await databaseReference.once()) ;
    Map<dynamic, dynamic>? vehiclesData = event.snapshot.value as Map?;
    List<Map<String, dynamic>> tempList = [];
    vehiclesData?.forEach((key, value) {
      Map<String, dynamic> vehicle = Map<String, dynamic>.from(value);
      vehicle['id'] = key; // Add the ID to the vehicle data
      tempList.add(vehicle);
    });
    setState(() {
      vehicles1 = tempList.cast<Vehicle>();
    });
  }

  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> _fetchFeaturedVehicles() async {
    databaseReference
        .child('vehicles')
        .orderByChild('status')
        .equalTo('Featured')
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

  Future<void> _fetchAffordableVehicles() async {
    databaseReference
        .child('vehicles')
        .orderByChild('status')
        .equalTo('affordable')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        setState(() {
          affordablevehicles.add(affordablevehicle(
            id:key,
            name: value['model_name'],
            imageUrl: value['VehicleImages'],
            speed: double.parse(value['speed'].toString()),
            pricePerDay: double.parse(value['price'].toString()),
            seats: value['seats'].toString(),
            vehiclenumber: value['vehicle_number'],
            transmission: value['Transmission'],
            EnginCap:value['EngineCapacity'].toString(),
            location: value['location'].toString(),
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
          lastName = documentSnapshot.get("LastName");
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
              child: Icon(
                Icons.logout,
                color: Colors.black,

              ),
            )
          ],
        ),
        body: Container(
          height: screenHeight,
          child: Column(children: [
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
              height: 260,
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
                        height: 249, // Adjust height as needed
                        child: PageView.builder(
                          itemCount: vehicles[index].imageUrl.length,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Container(
                              height: 212,
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
                                    title: Text(vehicles[index].name,style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold),),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top:119),
                                      child: Container(
                                        height: 47,
                                        margin: EdgeInsets.all(8.0),
                                        padding: EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF0047AB),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Row(

                                          children: [
                                            Image.asset('assets/images/SPEEDO.png', width: 50, height: 84),
                                            Text('${vehicles[index].speed} mph',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:   FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),

                                            Text("      |    " ,style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),),
                                            Image.asset('assets/images/money.png', width: 50, height: 80),
                                            Text(
                                              ' \$${vehicles[index].pricePerDay }',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ),
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
              height: 52,
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
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 8),
                  child: Text(
                    "Affordables",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

//Affordable cars

            Container(
              height: 284,
              width: 543,
              child: ListView(
                scrollDirection: Axis.horizontal,
                // Make the ListView scroll horizontally
                children: List.generate(
                  affordablevehicles.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 12,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          width: 200, // Adjust width as needed
                          child: PageView.builder(
                            itemCount:
                                affordablevehicles[index].imageUrl.length,
                            itemBuilder: (BuildContext context, int pageIndex ) {

                              return GestureDetector(
                                onTap: () {
                                  String vehicleId = affordablevehicles[index].id; // Assuming id is a field in the affordablevehicles model
                                  print(vehicleId);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VehicleDetailsPage(
                                                vehicleData:
                                                    affordablevehicles[index]
                                                        .toMap(),
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          affordablevehicles[index]
                                              .imageUrl[pageIndex]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children: [
                                            Text(affordablevehicles[index].name,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                                          ],
                                        ),
                                        subtitle:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            SizedBox(height: 174), // Adjust this value as needed
                                            Text(
                                                ' \$${affordablevehicles[index].pricePerDay}/Day',
                                                style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold), // Adjust font size as needed

                                            ),
                                          ],
                                        ),


                                        // Text(
                                        //   'Speed: ${affordablevehicles[index].speed} mph | Price Per Day: \$${affordablevehicles[index].pricePerDay}',
                                        // ),
                                      ),
                                    ],
                                  ),
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
            ),
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

class affordablevehicle {
  final String name;
  final String id;
  final String seats;
  final String vehiclenumber;
  final String location;
  final String EnginCap;
  final String transmission;

  final imageUrl;
  final double speed;
  final double pricePerDay;

  affordablevehicle({
    required this.name,
    required this.id,
    required this.vehiclenumber,
    required this.transmission,
    required this.EnginCap,
    required this.location,
    required this.seats,
    required this.imageUrl,
    required this.speed,
    required this.pricePerDay,

  });

  // Convert Vehicle object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      id:id,
      'model_name': name,
      'seats': seats,
      'speed': speed,
      'price': pricePerDay,
      'VehicleImages': imageUrl,
      'vehicle_number': vehiclenumber,
      'location': location,
      'Transmission': transmission,
      'EngineCapacity': EnginCap,
    };
  }
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

Widget _Hotdeals(Image image, String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 135,
      width: 126,
      decoration: BoxDecoration(
          color: Color(0xFF0047AB), borderRadius: BorderRadius.circular(23)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            SizedBox(width: 10),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: image, // Using the passed image widget
                ),

                // Text(
                //   '$title: ',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
