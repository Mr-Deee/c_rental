import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/AddVehicle.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SignUpScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(Duration(seconds: 2)); // Ad
  runApp( MyApp());
}

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
        initialRoute:
        FirebaseAuth.instance.currentUser == null ? '/SignIn' : '/AddNewVehicle',
        //'/Homepage',
        routes: {
          "/SignUP": (context) => SignUpScreen(),
          // "/Admin": (context) => Adminpage(),
          "/SignIn": (context) => LoginScreen(),
          // "/Employee": (context) => employeetill(),
          "/AddNewVehicle": (context) => NewVehicle(),
          //    "/addproduct":(context)=>addproduct()
        }


    );
  }
}

