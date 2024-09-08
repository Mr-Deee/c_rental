import 'package:c_rental/assistantmethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Users.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final String ?vehicleId; // Add vehicleId here
  VehicleDetailsPage({required this.vehicleData,  required this.vehicleId,  });



  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}
final DatabaseReference db = FirebaseDatabase.instance.ref();
class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  String? getSelectedVehicleId() {
    return widget.vehicleId;
  }


  @override
  void initState() {
    AssistantMethod.getCurrentOnlineUserInfo(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;

    return Scaffold(
      // backgroundColor: Color(0xFF0047AB),
      appBar: AppBar(
        backgroundColor: Color(0xFF0047AB),
        title: Text(
          widget.vehicleData['model_name'].toString(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: widget.vehicleData != null && widget.vehicleData.containsKey('VehicleImages')
                    ? Image.network(
                  widget.vehicleData['VehicleImages'][0],
                  height: 250,
                  width: 500,
                )
                    : Text('No image available'), // Display a message if image data is not available
              ),
            ),

            SizedBox(height: 10),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDetailRow(
                        Image.asset('assets/images/ENGINE.png',
                            width: 74, height: 74),
                        'Model Number',
                        widget.vehicleData['EngineCapacity']??"".toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/seats.png',
                            width: 74, height: 74),
                        'Number of Seats',
                        widget.vehicleData['seats'].toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/SPEEDO.png',
                            width: 74, height: 74),
                        'Number of Seats',
                        widget.vehicleData['speed'].toString()),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                _buildDetailRow(
                    Image.asset('assets/images/PLATE.png', width: 74, height: 74),
                    'Plate Number',
                    widget.vehicleData['vehicle_number'].toString()),
                _buildDetailRow(
                    Image.asset('assets/images/gear2.png', width: 74, height: 74),
                    'Plate Number',
                    widget.vehicleData['Transmission'].toString()),
              ],
            ),
            // Add more details as needed

            Container(
              height: 123,
              decoration: BoxDecoration(
                  color: Color(0xFF0047AB),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 18, right: 18),
                        child: Container(
                          height: 52,
                          width: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),
                          child: Center(
                              child: Text(
                            "Benjis",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            widget.vehicleData['location'].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("lOCATION"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_view_day,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                "Mon - Sun",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            // Add some space between the icon and text
                            Text(
                              "(233)503026630",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ), // Second icon
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 22,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                   Center(
                      child: Row(children: [
                          Text("\$${ widget.vehicleData['price']}/day",style: TextStyle(color: Colors.black,fontSize: 34),),

                        ],
                      )),
                Row(

                  children: [

                    GestureDetector(
                      onTap: (){
                        _showRentDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF0047AB),
                            borderRadius: BorderRadius.circular(10)

                        ),
                        height: 53,
                        width: 120,
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Rent Now",style: TextStyle(color: Colors.white),),
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                )
            ]),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(Image image, String title, String value) {
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


  void _showRentDialog() {
    TextEditingController daysController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text('Enter Number of Days for ${widget.vehicleData['model_name']}',style: TextStyle(fontSize: 15,),),
          content: TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Number of days"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                int days = int.parse(daysController.text);
        String? vehicleId = widget.vehicleId;
        if (vehicleId != null && vehicleId.isNotEmpty) {
        rentVehicle(vehicleId,  days);
        Navigator.of(context).pop();
        } else {
        print('Invalid vehicle ID');
        }}
            ),
          ],
        );
      },
    );
  }
// Convert DateTime to a timestamp (milliseconds since epoch)
  int timestamp = DateTime.now().millisecondsSinceEpoch;

// or convert DateTime to a formatted string
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  Future<void> rentVehicle(String vehicleId,  int days) async {
    final userprovider = Provider.of<Users>(context,listen: false).userInfo;

    if (vehicleId == null || vehicleId.isEmpty) {
      print('Invalid vehicle ID');
      return;
    }

    DatabaseReference vehiclesRef = db.child('vehicles');
    DatabaseReference rentedRef = db.child('Rented');

    try {
      // Update vehicle status
      await vehiclesRef.child(vehicleId).update({'RentedStatus': 'rented'});

      // Add entry to rented table
      await rentedRef.push().set({
        'imageUrl':widget.vehicleData['VehicleImages'],

        'vehicleId': vehicleId,
        'userName': userprovider?.lastname,
        'Email':userprovider?.email,
        'brand': widget.vehicleData['model_name']?.toString() ?? 'Unknown',
        'EngineCap': widget.vehicleData['EngineCapacity']?? 'Unknown',
        'Seats':  widget.vehicleData['seats']?? 'Unknown',
        'Transmission': widget.vehicleData['Transmission']?? 'Unknown',
        'pricePerDay': widget.vehicleData['price'] ?? 0,
        'totalPrice': (widget.vehicleData['price'] ?? 0) * days,
        'rentalDays': days,
        'rentedAt': formattedDate,
      });
      _showSuccessMessage();
      print('Vehicle rented successfully');
    } catch (e) {
      print('Failed to rent vehicle: $e');
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Vehicle rented successfully"),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}


