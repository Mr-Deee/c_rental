import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'VehicleDetails.dart';

class VehiclePage extends StatefulWidget {
  final String vehicleName;

  VehiclePage({required this.vehicleName});

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  List<Map<String, dynamic>> vehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchVehicles();
  }
  Future<Map<String, dynamic>> _getVehicleDetails(String modelName) async {
    DatabaseReference vehiclesRef =
    FirebaseDatabase.instance.ref().child('vehicles');

      DatabaseEvent event = await vehiclesRef
        .orderByChild('model_name')
        .equalTo(modelName)
        .once();

    Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
    if (values != null) {
      var vehicleData = values.values.first;
      return Map<String, dynamic>.from(vehicleData);
    } else {
      return {};
    }
  }

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
            vehicles.add(Map<String, dynamic>.from(value));
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
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : vehicles.isEmpty
              ? Center(
                  child: Text('No vehicles found'),
                )
              : ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailsPage(
                              vehicleData: vehicles[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(vehicles[index]['model_name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text('Manufacturer: ${vehicles[index]['manufacturer']}'),
                              // Text('Year: ${vehicles[index]['year']}'),
                              // Add more details as needed
                            ],
                          ),
                          leading: Image.network(vehicles[index]['VehicleImages']
                              [1]), // You can display images here too
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
