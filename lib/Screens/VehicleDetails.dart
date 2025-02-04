import 'package:c_rental/assistantmethods.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hubtel_merchant_checkout_sdk/hubtel_merchant_checkout_sdk.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Users.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final String? vehicleId; // Add vehicleId here
  VehicleDetailsPage({
    required this.vehicleData,
    required this.vehicleId,
  });

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
      merchantApiKey:
          "eEdwelEyMzpkMmE2ZGI2NjRiNDE0ZDgwYWQxNGM3NTAxZTM1NjgxOA==");

  @override
  void initState() {
    AssistantMethod.getCurrentOnlineUserInfo(context);
    // TODO: implement initState
    super.initState();
  }

  // The phone number to call
  final String phoneNumber = "+233263909154"; // Replace with the desired phone number

  // Function to launch the phone dialer
  void _launchCaller(String number) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $number";
    }
  }
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;
    List<String>? images = widget.vehicleData['VehicleImages']?.cast<String>();

    return Scaffold(
      // backgroundColor: Color(0xFF0047AB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D94FF),
        // Navy blue
        title: Text(
          widget.vehicleData['model_name'].toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Increased font size for better visibility
            color: Colors.white,
            letterSpacing: 1.2, // Slightly increased letter spacing
          ),
        ),
        centerTitle: true,
        // Centers the title
        elevation: 4,
        // Adds a shadow effect for better depth
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          //   onPressed: () {
          //     // Add functionality here
          //   },
          // ),
        ],
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
                Container(
                  height: 78,
                    width: 236,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(27)),
                        gradient: LinearGradient(colors: [Color(0xFF040404), Color(0x860D94FF)])),
                    child: Padding(
                      padding: const EdgeInsets.only(left:5.0, right: 2.0,top: 30,bottom:20),
                      child: Text(
                        "\GHS-${widget.vehicleData['insideAccraprice_per_day']} - ${widget.vehicleData['outsideAccraprice_per_day']}day",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            )),

            Center(
              child: Container(

                height: 220,
                width: 500,
                child: images != null && images.isNotEmpty
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 180,

                    autoPlay: true, // Enables auto-slide
                    enlargeCenterPage: true, // Zooms in the center image slightly
                    viewportFraction: 0.8, // Adjusts the fraction of the screen each image takes
                  ),
                  items: images.map((image) {
                    return Image.network(
                      image,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                )
                    : const Center(child: Text('No image available')),
              ),
            ),

            SizedBox(height: 6),
           Center(
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDetailRow(
                            Image.asset('assets/images/ENGINE.png',
                                width: 78, height: 74),
                            'Model Number',
                            widget.vehicleData['EngineCapacity'] ?? "".toString()),
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



            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDetailRow(
                        Image.asset('assets/images/PLATE.png',
                            width: 74, height: 74),
                        'Plate Number',
                        widget.vehicleData['vehicle_number'].toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/gear2.png',
                            width: 74, height: 74),
                        'Plate Number',
                        widget.vehicleData['Transmission'].toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/gear2.png',
                            width: 74, height: 74),
                        'location',
                        widget.vehicleData['location'].toString()),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 22,
            ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0, left: 18, right: 18),
                                child: Container(
                                  height: 62,
                                  width: 73,
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
                  Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0, left: 18, right: 18),
                                child: GestureDetector(
                                  onTap: (){

                                    _launchCaller(phoneNumber); // Launch the dialer when tapped

                                  },
                                  child: Container(
                                    height: 62,
                                    width: 73,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(colors: [Color(0xF50D94FF), Color(0x860D94FF)])),

                                    child: Center(
                                        child: Icon(
                                      Icons.call,color: Colors.white,
                                    )),
                                  ),
                                ),
                           ),
                  GestureDetector(
                    onTap: () {
                      _showRentDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF0D94FF),
                          borderRadius: BorderRadius.circular(10)),
                      height: 53,
                      width: 120,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Rent Now",
                            style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                          ),
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
            color: Color(0xFF0D94FF), borderRadius: BorderRadius.circular(23)),
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


                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
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

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              titlePadding: const EdgeInsets.all(20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                "Rent a Vehicle",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for location selection
                  DropdownButtonFormField<String>(
                    value: selectedLocation,
                    hint: Text(
                      "Choose Location",
                      style: TextStyle(fontSize: 16, color: Colors.blue[600]),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "insideAccra",
                        child: Text(
                          "Inside Accra - GHS ${widget.vehicleData['insideAccraprice_per_day'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "outsideAccra",
                        child: Text(
                          "Outside Accra - GHS ${widget.vehicleData['outsideAccraprice_per_day'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Display price based on selected location
                  Text(
                    selectedLocation == "insideAccra"
                        ? "Price: GHS ${widget.vehicleData['insideAccraprice_per_day'] ?? 'N/A'}"
                        : selectedLocation == "outsideAccra"
                            ? "Price: GHS ${widget.vehicleData['outsideAccraprice_per_day'] ?? 'N/A'}"
                            : "Select a location",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Input for number of days
                  TextField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Number of days",
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(color: Colors.blue[400]),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(20),
              actions: <Widget>[
                // Cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // Proceed button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed To Pay',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    var price = selectedLocation == "insideAccra"
                        ? widget.vehicleData['insideAccraprice_per_day']
                        : widget.vehicleData['outsideAccraprice_per_day'];

                    print("Price per day: $price");
                    String? FName = userprovider!.firstname;
                    String? lName = userprovider!.lastname;
                    String? phone = userprovider!.phone;

                    int days = int.parse(daysController.text);
                    String? vehicleId = widget.vehicleId;
                    if (vehicleId != null && vehicleId.isNotEmpty) {
                      var finalprice = price * days;
                      print(finalprice);
                      final onCheckoutCompleted = Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckoutScreen(
                          purchaseInfo: PurchaseInfo(
                              amount: finalprice,
                              customerPhoneNumber: phone.toString(),
                              purchaseDescription: "BENJI-Rental",
                              clientReference: "REFe"),
                          configuration: hubtelConfig,
                          themeConfig: ThemeConfig(primaryColor: Colors.black),
                        );
                      }));
                      if (onCheckoutCompleted is CheckoutCompletionStatus) {
                        rentVehicle(vehicleId, days);
                        Navigator.of(context).pop();
                      }
                    } else {
                      print('Invalid vehicle ID');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// Convert DateTime to a timestamp (milliseconds since epoch)
  int timestamp = DateTime.now().millisecondsSinceEpoch;

// or convert DateTime to a formatted string
  String formattedDate =
      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

  Future<void> rentVehicle(String vehicleId, int days) async {
    final userprovider = Provider.of<Users>(context, listen: false).userInfo;

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
        'imageUrl': widget.vehicleData['VehicleImages'],
        'vehicleId': vehicleId,
        'userName': userprovider?.lastname,
        'Email': userprovider?.email,
        'brand': widget.vehicleData['model_name']?.toString() ?? 'Unknown',
        'EngineCap': widget.vehicleData['EngineCapacity'] ?? 'Unknown',
        'Seats': widget.vehicleData['seats'] ?? 'Unknown',
        'Transmission': widget.vehicleData['Transmission'] ?? 'Unknown',
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
