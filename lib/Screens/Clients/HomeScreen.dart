import 'dart:async';

import 'package:c_rental/Users.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../Drawers/DrawerUser.dart';
import '../../assistantmethods.dart';
import 'AllVehicles.dart';
import 'IconVehicles.dart';
import 'LoginScreen.dart';
import '../ProfilUserScreen.dart';
import '../VehicleDetails.dart';

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
  final List<LogoData> logos = [
    LogoData("Honda", "assets/images/honda2.png", 70.0),
    LogoData("Toyota", "assets/images/toyota.png", 45.0),
    LogoData("Mistubishi", "assets/images/Mitsubishi.png", 42.0),
    LogoData("Hyundai", "assets/images/hyundai.png", 43.0),
    LogoData("Nissan", "assets/images/Nissa.png", 44.0),
  ];

  @override
  void initState() {
    doSomeAsyncStuff();
    _fetchfeaturedVehicles();
    _fetchAffordableVehicles();
    AssistantMethod.getCurrentOnlineUserInfo(context);

    super.initState();
  }

  final databaseReference = FirebaseDatabase.instance.ref();


  Future<void> _fetchfeaturedVehicles() async {
    databaseReference
        .child('vehicles')
        .orderByChild('classification')
        .equalTo('Featured')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        setState(() {
          vehicles.add(Vehicle(
            id: key,
            name: value['model_name'],
            imageUrl: value['VehicleImages'],
            speed: double.parse(value['speed'].toString()),
            inseaccrapricePerDay: double.parse(value['insideAccraprice_per_day'].toString()),
            outsideaccrapricePerDay: double.parse(value['outsideAccraprice_per_day'].toString()),
            seats: value['seats'].toString(),
            vehiclenumber: value['vehicle_number'],
            transmission: value['Transmission'].toString(),
            EnginCap: value['EngineCapacity'].toString(),
            location: value['location'].toString(), vehiclemake:value[ 'vehicle_make'],
          ));
        });
      });
    });
  }



  Future<void> _fetchAffordableVehicles() async {
    databaseReference
        .child('vehicles')
        .orderByChild('classification')
        .equalTo('Affordable')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        setState(() {
          affordablevehicles.add(affordablevehicle(
            id: key,
            name: value['model_name'],
            imageUrl: value['VehicleImages'],
            speed: double.parse(value['speed'].toString()),
            seats: value['seats'].toString(),
            vehiclenumber: value['vehicle_number'],
            transmission: value['Transmission'],
            EnginCap: value['EngineCapacity'].toString(),
            location: value['location'].toString(), vehiclemake: ['vehicle_make'].toString(),
              inseaccrapricePerDay: double.tryParse(value["insideAccraprice_per_day"]?.toString() ?? '0.0') ?? 0.0,
            outsideaccrapricePerDay: double.tryParse(value['outsideAccraprice_per_day']?.toString() ?? '0.0') ?? 0.0,
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
         // lastName = documentSnapshot.get("LastName");
        });
        // print('Document data: ${documentSnapshot.get("lastName")}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return
      Scaffold(
        drawer: DrawerUser(),

        appBar: AppBar(
          title: Text("Benji's",style: TextStyle(color:Color(0xFF0047AB),fontWeight: FontWeight.bold),),
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
                color: Color(0xFF0047AB),
              ),
            )
          ],
        ),
        body: Container(
          height: screenHeight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Section Title
                // Featured Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // This ensures the "All" text is aligned to the far right
                    children: [
                      Text(
                        "Featured",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0047AB),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigate to the new page showing all vehicles
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllVehiclesPage(),
                            ),
                          );
                        },
                        child: Text(
                          "All",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Affordable Vehicles
                Container(
                  height: 284,
                  width: screenWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          String vehicleId =vehicles[index]
                              .id; // Assuming id is a field in the affordablevehicles model
                          print(vehicleId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleDetailsPage(
                                        vehicleData:
                                        vehicles[index]
                                            .toMap(),
                                        vehicleId: vehicleId,
                                      )));

                        },
                        child: Container(
                              margin: const EdgeInsets.all(5.0),
                              width: screenWidth * 0.96, // 60% of the screen width

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [Color(0xFF0047AB), Color(0xFF82B1FF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      vehicles[index].imageUrl[0],
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/addc.png',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  '${vehicles[index].name}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 1, // Thickness of the divider
                                              height: 24, // Adjust height based on your content
                                              color: Colors.white.withOpacity(0.5), // Divider color
                                            ),
                                            // First Row
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/SPEEDO.png',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  '${vehicles[index].speed} mph',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Divider
                                            Container(
                                              width: 1, // Thickness of the divider
                                              height: 24, // Adjust height based on your content
                                              color: Colors.white.withOpacity(0.5), // Divider color
                                            ),
                                            // Second Row
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/money.png',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  '\$${vehicles[index].inseaccrapricePerDay}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Divider
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );

                    },
                  ),
                ),

                // Logos Section
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  height: 52,
                  child: Row(
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
                        });                      },
                      child: Image.asset(
                        logo.imageUrl,
                        width: 50,
                        height: 40,
                      ),
                    ))
                        .toList(),
                  ),
                ),

                // Affordables Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
                  child: Text(
                    "Affordables",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0047AB),
                    ),
                  ),
                ),

                // Affordable Vehicles
                Container(
                  height: 284,
                  width: screenWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: affordablevehicles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          String vehicleId = affordablevehicles[index]
                              .id; // Assuming id is a field in the affordablevehicles model
                          print(vehicleId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleDetailsPage(
                                        vehicleData:
                                        affordablevehicles[index]
                                            .toMap(),
                                        vehicleId: vehicleId,
                                      )));                        },
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          width: screenWidth * 0.6, // 60% of the screen width

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Color(0xFF0047AB), Color(0xFF82B1FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.network(
                                  affordablevehicles[index].imageUrl[0],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      '\$${affordablevehicles[index].outsideaccrapricePerDay}/Day',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        )




    );
  }

  void _showRentDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Rent Vehicle',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
          content: Text('Do you want to rent ${vehicles[index].name}?',style: TextStyle(fontSize: 11),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Add your code here to rent the vehicle
                Navigator.of(context).pop();
              },
              child: Text('Rent',style: TextStyle(color: Colors.black),),
            ),
            TextButton(
        //       style: ButtonStyle(
        // backgroundColor: MaterialStateProperty.all(Colors.red),         ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: Colors.red),),
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
  final String vehiclenumber;
  final String vehiclemake;
  final String seats;
  final String EnginCap;
  final String id;
  final String location;
  final imageUrl;
  final double speed;
  final String transmission;
  final double inseaccrapricePerDay;
  final double outsideaccrapricePerDay;

  Vehicle({
    required this.id,
    required this.vehiclemake,
    required this.name,
    required this.imageUrl,
    required this.speed,
    required this.inseaccrapricePerDay,
    required this.outsideaccrapricePerDay,
    required this.transmission,
    required this.vehiclenumber,
    required this.seats,
    required this.EnginCap,
    required this. location,
  });

  // Convert Vehicle object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      id: id,
      'model_name': name,
      'seats': seats,
      'speed': speed,
      'insideAccraprice_per_day': inseaccrapricePerDay,
      'outsideAccraprice_per_day': outsideaccrapricePerDay,
      'vehicle_make': vehiclemake,
      'VehicleImages': imageUrl,
      'vehicle_number': vehiclenumber,
      'location': location,
      'Transmission': transmission,
      'EngineCapacity': EnginCap,
    };
  }
}

class affordablevehicle {
  final String name;
  final String id;
  final String vehiclemake;
  final String seats;
  final String vehiclenumber;
  final String location;
  final String EnginCap;
  final String transmission;
  final imageUrl;
  final double speed;
  final double outsideaccrapricePerDay;
  final double inseaccrapricePerDay;

  affordablevehicle({
    required this.name,
    required this.id,
    required this.vehiclemake,
    required this.outsideaccrapricePerDay,
    required this.inseaccrapricePerDay,

    required this.vehiclenumber,
    required this.transmission,
    required this.EnginCap,
    required this.location,
    required this.seats,
    required this.imageUrl,
    required this.speed,
  });

  // Convert Vehicle object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      id: id,
      'model_name': name,
      'vehicle_make': vehiclemake,
      'seats': seats,
      'speed': speed,
      'insideAccraprice_per_day': inseaccrapricePerDay,
      'outsideAccraprice_per_day': outsideaccrapricePerDay,
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
  final double size;

  LogoData(this.name, this.imageUrl, [this.size = 0.0]); // Default size to 0.0
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
