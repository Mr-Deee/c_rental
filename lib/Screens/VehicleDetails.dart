import 'package:c_rental/assistantmethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
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
  String? selectedLocation; // State variable for dropdown selection

  final hubtelConfig = HubtelCheckoutConfiguration(
      merchantID: "2028852",
      callbackUrl: "https://webhook.site/84489ff4-28cf-476f-9dfb-67f1ea878c7c",
      merchantApiKey: "eEdwelEyMzpkMmE2ZGI2NjRiNDE0ZDgwYWQxNGM3NTAxZTM1NjgxOA=="
  );


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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Text("\GHS-${ widget.vehicleData['insideAccraprice_per_day']} - ${ widget.vehicleData['outsideAccraprice_per_day']}  day",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),),

                ],
                )),

            Center(
              child: Container(
                child: widget.vehicleData != null && widget.vehicleData.containsKey('VehicleImages')
                    ? Image.network(
                  widget.vehicleData['VehicleImages'][0],
                  height: 220,
                  width: 500,
                )
                    : Text('No image available'), // Display a message if image data is not available
              ),
            ),

            SizedBox(height: 6),
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
                          Text("LOCATION",style: TextStyle(color: Colors.white),),
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
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 135,
        width: 112,
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
    String? selectedLocation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final userprovider = Provider.of<Users>(context).userInfo;

        return AlertDialog(
          title: Row(
            children: [
              DropdownButton<String>(
                value: selectedLocation,
                hint: const Text("Choose Location"),
                items: [
                  DropdownMenuItem(
                    value: "insideAccra",
                    child: Text("Inside Accra - GHS ${widget.vehicleData['insideAccraprice_per_day'] ?? 'N/A'}"),
                  ),
                  DropdownMenuItem(
                    value: "outsideAccra",
                    child: Text("Outside Accra - GHS ${widget.vehicleData['outsideAccraprice_per_day'] ?? 'N/A'}"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value; // Update the selected location
                  });
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display price based on the selected location
              Text(
                selectedLocation == "insideAccra"
                    ? "Price: GHS ${widget.vehicleData['insideAccraprice_per_day'] ?? 'N/A'}"
                    : selectedLocation == "outsideAccra"
                    ? "Price: GHS ${widget.vehicleData['outsideAccraprice_per_day'] ?? 'N/A'}"
                    : "Select a location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Number of days input
              TextField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Number of days"),
              ),
            ],
          ),

          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Proceed To Pay'),
              onPressed: () {

 var price =widget.vehicleData['price_per_day'];



 print("new$price");
String? FName = userprovider!.firstname;
String? lName = userprovider!.lastname;
String? phone = userprovider!.phone;


                int days = int.parse(daysController.text);
        String? vehicleId = widget.vehicleId;
        if (vehicleId != null && vehicleId.isNotEmpty) {

          var finalprice =widget.vehicleData['price_per_day']*days;
          print(finalprice);
          final onCheckoutCompleted = Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) {
                    return CheckoutScreen(
                      purchaseInfo: PurchaseInfo(
                          amount:finalprice,
                          customerPhoneNumber:phone.toString(),
                          purchaseDescription: "BENJI-Rental",
                          clientReference: "REFe"),
                      configuration:hubtelConfig,
                      themeConfig: ThemeConfig(
                          primaryColor:
                          Colors.black),
                    );
                  }));
          if (onCheckoutCompleted is CheckoutCompletionStatus){


            rentVehicle(vehicleId,  days);
            Navigator.of(context).pop();
            //Your activity after checkout Completion.
          }


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


