import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Users.dart';
// import '../otherUserModel.dart';

class AssistantMethod{




  static void getCurrentOnlineUserInfo(BuildContext context) async {
    print('assistant methods step 3:: get current online user info');
    firebaseUser = FirebaseAuth.instance.currentUser; // CALL FIREBASE AUTH INSTANCE
    print('assistant methods step 4:: call firebase auth instance');
    String? userId = firebaseUser!.uid; // ASSIGN UID FROM FIREBASE TO LOCAL STRING
    print('assistant methods step 5:: assign firebase uid to string');
    print(userId);
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Clients").child(userId);
    print(
        'assistant methods step 6:: call users document from firebase database using userId');
    reference.once().then(( event) async {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value!= null) {
        print(
            'assistant methods step 7:: assign users data to usersCurrentInfo object');

        DatabaseEvent event = await reference.once();
        print(event);

        context.read<Users>().setUser(Users.fromMap(Map<String, dynamic>.from(event.snapshot.value as dynamic)));
        print('assistant methods step 8:: assign users data to usersCurrentInfo object');
        print(Users().firstname);

      }
    }
    );






  }




  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }

}