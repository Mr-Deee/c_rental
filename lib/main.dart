import 'package:c_rental/Screens/Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Screens/AddVehicle.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SignUpScreen.dart';
import 'Screens/VehicleScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(Duration(seconds: 2)); // Ad
  runApp(MyApp());
}

DatabaseReference Clientsdb = FirebaseDatabase.instance.ref().child("Clients");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Benji Rental Services',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        debugShowCheckedModeBanner: false,
        initialRoute:'/',
            // FirebaseAuth.instance.currentUser == null ? '/SignUP' : '/Admin',
        //'/Homepage',
        routes: {
          "/": (context) => CheckUserRole(),
          "/SignUP": (context) => SignUpScreen(),
          "/VehicleScreen": (context) => VehicleScreen(),
          "/HomeScreen": (context) => HomeScreen(),
          "/SignIn": (context) => LoginScreen(),
          "/Admin": (context) => Admin(),
        });
  }
}
class CheckUserRole extends StatefulWidget {
@override
_CheckUserRoleState createState() => _CheckUserRoleState();
}

class _CheckUserRoleState extends State<CheckUserRole> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _checkUserRoleAndNavigate();
  }
  void _checkUserRoleAndNavigate() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent adminSnapshot = await _databaseReference.child('Admin').once();
      DatabaseEvent gasStationSnapshot = await _databaseReference.child('Clients').once();

      if (adminSnapshot.snapshot.value != null &&
          (adminSnapshot.snapshot.value as Map<dynamic, dynamic>).containsKey(user.uid)) {
        // User is an admin
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/Admin');});
      } else if (gasStationSnapshot.snapshot.value != null &&
          (gasStationSnapshot.snapshot.value as Map<dynamic, dynamic>).containsKey(user.uid)) {
        // User is a gas station

        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/HomeScreen');});
      } else {
        // User is not assigned a role
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/Admin');});
      }
    } else {
      // No user logged in
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/SignIn');});
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator while checking user role
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}