import 'package:animate_do/animate_do.dart';
import 'package:c_rental/Screens/Rentals.dart';
import 'package:c_rental/Screens/VehicleInventory.dart';
import 'package:c_rental/Screens/payment%20and%20Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AddVehicle.dart';
import 'ClientComplaints.dart';

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
  final Query _clientRef = FirebaseDatabase.instance.ref().child('Clients');

  int availableVehiclesCount = 0;
  int availablerentedvehicles = 0;
  int availableclients = 0;

  @override
  void initState() {
    super.initState();
    _listenForAvailableVehicles();
    _listenForRentedVehicles();
    _listenForClients();
  }

  void _listenForAvailableVehicles() {
    _vehiclesRef.onValue.listen((DatabaseEvent event) {
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

  void _listenForRentedVehicles() {
    _rentedRef.onValue.listen((DatabaseEvent event) {
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

  void _listenForClients() {
    _clientRef.onValue.listen((DatabaseEvent event) {
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard", style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              _showSignOutDialog(context);
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSummaryCards(),
            _buildMenuOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSummaryCard("Available Cars", availableVehiclesCount.toString(), Colors.green),
            _buildSummaryCard("Rented Cars", availablerentedvehicles.toString(), Colors.orange),
            _buildSummaryCard("Total Clients", availableclients.toString(), Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return FadeInDown(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color,
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuOption(context, "Add New Vehicle", "assets/images/addnew.png", AddVehiclePage()),
              _buildMenuOption(context, "Check Rentals", "assets/images/addc.png", RentalVehicles()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuOption(context, "Vehicle Inventory", "assets/images/addnew.png", VehicleInventory()),
              _buildMenuOption(context, "Payment & Users", "assets/images/addc.png", PaymentandUsers()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInLeft(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Complaints()));
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: 380,
                      height: 130,
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/ic_launcher.png', width: 110, height: 120),
                                const SizedBox(height: 8),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Center(
                              child: Text(
                                "Client Complaints",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 33),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String title, String imagePath, Widget page) {
    return FadeInLeft(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
        },
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, width: 60, height: 60),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to sign out?', style: GoogleFonts.openSans()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (route) => false);
              },
              child: Text('Yes', style: GoogleFonts.openSans(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: GoogleFonts.openSans(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
