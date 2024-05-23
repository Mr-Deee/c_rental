import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
// import '../otherUserModel.dart';

class AssistantMethod{




  static void getCurrentOnlineUserInfo(BuildContext context) async {
    print('assistant methods step 3:: get current online user info');
    firebaseUser = FirebaseAuth.instance.currentUser; // CALL FIREBASE AUTH INSTANCE
    print('assistant methods step 4:: call firebase auth instance');
    String? userId = firebaseUser!.uid; // ASSIGN UID FROM FIREBASE TO LOCAL STRING
    print('assistant methods step 5:: assign firebase uid to string');
    print(userId);
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Riders").child(userId);
    print(
        'assistant methods step 6:: call users document from firebase database using userId');
    reference.once().then(( event) async {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value!= null) {
        print(
            'assistant methods step 7:: assign users data to usersCurrentInfo object');

        DatabaseEvent event = await reference.once();
        print(event);

        context.read<Ride_r>().setRider(Ride_r.fromMap(Map<String, dynamic>.from(event.snapshot.value as dynamic)));
        print('assistant methods step 8:: assign users data to usersCurrentInfo object');
        print(Users().firstname);

      }
    }
    );






  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms of GHS
    double timeTravelFare = (directionDetails.durationValue! / 60) * 0.20;
    double distanceTraveledFare = (directionDetails.distanceValue! / 1000) *
        0.20;
    double totalFareAmount = timeTravelFare + distanceTraveledFare;

    //1$ = 5.76
    double totalLocalAmount = totalFareAmount * 160;

    if (rideType == "Rev-x") {
      double result = (totalFareAmount.truncate()) * 2.0;
      return result.truncate();
    }
    else if (rideType == "Rev-Executive") {
      return totalFareAmount.truncate();
    }
    else if (rideType == "Rev-standard") {
      double result = (totalFareAmount.truncate()) / 2.0;
      return result.truncate();
    }
    else {
      return totalFareAmount.truncate();
    }
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void obtainTripRequestsHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
    {
      clientRequestRef.child(key).once().then((event) {

        print("newevent:$event");
        // var dataSnapshot = event.snapshot;
        // final map = dataSnapshot.value ;
        if( event.snapshot.value!= null)
        {
          history = History.fromSnapshot(event.snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
        }
      });
    }
  }



  static void retrieveHistoryInfo(context)
  {


    Ridersdb.child(currentfirebaseUser!.uid).child("earnings").once().then((
        event) {

      // var dataSnapshot = value.snapshot;
      // final map = dataSnapshot.value as Map<dynamic, dynamic>;
      if( event.snapshot.value!= null){
        String earnings = event.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);

        print("earnings:$earnings");
      }
    });
    //retrieve and display Trip History
    clientRequestRef.orderByChild("driver_name").once().then((event)
    {
      final dataSnapshot = event.snapshot;
      if(dataSnapshot.value != null)
      {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> keys = dataSnapshot.value as Map<dynamic, dynamic>;

        print('assistant methods step 84::{}');
        //update total number of trip counts to provider
        // Map<dynamic, dynamic> keys = dataSnapshot as Map;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);
        print('assistant methods step 84::{}');
        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value)
        {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
      }
    });
  }






  static void disableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription?.pause();
    Geofire.removeLocation(currentfirebaseUser!.uid);
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition
        .latitude},${initialPosition.longitude}&destination=${finalPosition
        .latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
    res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
    res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
    res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
    res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
    res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }


  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }

}