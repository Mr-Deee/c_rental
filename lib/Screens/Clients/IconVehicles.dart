import 'package:c_rental/Screens/Clients/HomeScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../VehicleDetails.dart';

class VehiclePage extends StatefulWidget {
  final String vehicleName;

  VehiclePage({required this.vehicleName});

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  // List<Map<String, dynamic>> vehicles = [];
  bool isLoading = true;
  List<affordablevehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    _searchVehicles();
  }

  // Future<Map<String, dynamic>> _getVehicleDetails(String modelName) async {
  //   DatabaseReference vehiclesRef =
  //   FirebaseDatabase.instance.ref().child('vehicles');
  //
  //     DatabaseEvent event = await vehiclesRef
  //       .orderByChild('model_name')
  //       .equalTo(modelName)
  //       .once();
  //
  //   Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
  //   if (values != null) {
  //     var vehicleData = values.values.first;
  //     return Map<String, dynamic>.from(vehicleData);
  //   } else {
  //     return {};
  //   }
  // }
  String? vehid;

  void _searchVehicles() {
    DatabaseReference vehiclesRef =
    FirebaseDatabase.instance.ref().child('vehicles');

    vehiclesRef
        .orderByChild('model_name')
        .equalTo(widget.vehicleName)
        .once()
        .then((DatabaseEvent event) {
      setState(() {
        isLoading = false;
      });
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      if (values != null) {
        values.forEach((key, value) {
          setState(() {
            vehicles.add(
              affordablevehicle(
                id: key,

                // Assigning the Firebase key as ID
                name: value['model_name'],
                seats: value['seats'].toString(),
                speed: double.parse(value['speed'].toString()),
                outsideaccrapricePerDay: double.parse(value['outsideAccraprice_per_day'].toString()),
                imageUrl: value['VehicleImages'],
                vehiclenumber: value['vehicle_number'],
                transmission: value['Transmission'],
                EnginCap: value['EngineCapacity'].toString(),
                location: value['location'],
                 vehiclemake: value['vehicle_make'],
                inseaccrapricePerDay:  double.parse(value["insideAccraprice_per_day"]),
              ),
            );
          });
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicleName),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : vehicles.isEmpty
          ? Center(
        child: Text(
          'No vehicles found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              String vehicleId = vehicles[index].id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleDetailsPage(
                    vehicleData: vehicles[index].toMap(),
                    vehicleId: vehicleId,
                  ),
                ),
              );
            },
            child:Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vehicle Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              vehicles[index].imageUrl[0],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Expanded Column for Vehicle Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vehicle Name and Make
                                Row(
                                  children: [
                                    Text(
                                      vehicles[index].name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      vehicles[index].vehiclemake,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                // Row for Price and Location
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Price
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on,
                                            size: 18, color: Colors.green),
                                        Text(
                                          " \$${vehicles[index].inseaccrapricePerDay}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on,
                                            size: 18, color: Colors.green),
                                        Text(
                                          " \$${vehicles[index].outsideaccrapricePerDay}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Location
                                    Text(
                                      vehicles[index].location,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Row for Manufacturer and Other Details
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Manufacturer Icon and Name
                                    // Row(
                                    //   children: [
                                    //     Icon(Icons.directions_car,
                                    //         size: 18, color: Colors.blue.shade400),
                                    //     const SizedBox(width: 5),
                                    //     Text(
                                    //       vehicles[index].name,
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         color: Colors.grey.shade700,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

              ),
            )

          );
        },
      ),
    );
  }

}