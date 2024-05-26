import 'package:animate_do/animate_do.dart';
import 'package:c_rental/Screens/Rentals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final DatabaseReference _vehiclesRef =
      FirebaseDatabase.instance.ref().child('vehicles');
  final Query _rentedRef = FirebaseDatabase.instance
      .ref()
      .child('vehicles')
      .orderByChild("RentedStatus")
      .equalTo("rented");

  final Query _clientRef = FirebaseDatabase.instance
      .ref()
      .child('Clients');


  int availableVehiclesCount = 0;
  int availablerentedvehicles = 0;
  int availableclients = 0;

  @override
  void initState() {
    super.initState();
    _fetchAvailableVehiclesCount();
    _fetchAvailableRentedVehiclesCount();
    _fetchAvailableClient();
  }

  void _fetchAvailableVehiclesCount() {
    _vehiclesRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        int count = 0;
        data.forEach((key, value) {
          if (value['rent'] == null) {
            count++;
          }
        });
        setState(() {
          availableVehiclesCount = count;
        });
      }
    });
  }

  void _fetchAvailableRentedVehiclesCount() {
    _rentedRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        int count = 0;
        data.forEach((key, value) {
          if (value != null) {
            count++;
          }
        });
        setState(() {
          availablerentedvehicles = count;
        });
      }
    });
  }

  void _fetchAvailableClient() {
    _clientRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        int count = 0;
        data.forEach((key, value) {
          if (value != null) {
            count++;
          }
        });
        setState(() {
          availableclients = count;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size; //check the size of device
    final arg = (ModalRoute.of(context)?.settings.arguments ??
        <dynamic, dynamic>{}) as Map;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          IntrinsicHeight(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 18.0),
                                  child: Text(
                                    "Available Cars",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 18.0),
                                  child: Text(
                                    availableVehiclesCount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: VerticalDivider(
                              thickness: 2,
                              width: 30,
                              color: Colors.white,
                            ),
                          ),
                          IntrinsicHeight(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 18.0),
                                  child: Text(
                                    "Rented Cars",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 18.0),
                                  child: Text(
                                    availablerentedvehicles.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: VerticalDivider(
                              thickness: 2,
                              width: 30,
                              color: Colors.white,
                            ),
                          ),
                          IntrinsicHeight(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 18.0),
                                  child: Text(
                                    "Total Clients",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, top: 18.0),
                                  child: Text(
                                    availableclients.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
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
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Image.asset(
                                  "assets/images/addnew.png",
                                  width: 140,
                                  height: 102,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, left: 50, right: 30),
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
                  ),
                  SizedBox(
                    height: 180,
                    width: 180,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => RentalVehicles()),
                            (Route<dynamic> route) => true);
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.white,
                        shadowColor: Colors.white70,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 19.0),
                              child: Image.asset(
                                "assets/images/addc.png",
                                width: 180,
                                height: 92,
                              ),
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
