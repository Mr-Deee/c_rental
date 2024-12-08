import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../VehicleDetails.dart';
import 'HomeScreen.dart';

class AllVehiclesPage extends StatefulWidget {
  final List<Vehicle> vehicles;

  AllVehiclesPage({required this.vehicles});

  @override
  _AllVehiclesPageState createState() => _AllVehiclesPageState();
}

class _AllVehiclesPageState extends State<AllVehiclesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Vehicles'),
      ),

      body: ListView.builder(
    itemCount: widget.vehicles.length,
      itemBuilder: (context, index) {
        String vehicleImageUrl = widget.vehicles[index].imageUrl.isNotEmpty
            ? widget.vehicles[index].imageUrl[0]
            : 'https://example.com/default-image.png'; // fallback image URL

        return GestureDetector(
          onTap: () {
            String vehicleId = widget.vehicles[index].id;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleDetailsPage(
                  vehicleData: widget.vehicles[index].toMap(),
                  vehicleId: vehicleId,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Color(0xFF0047AB), Color(0xFF82B1FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Image.network(
                    vehicleImageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/addc.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${widget.vehicles[index].name}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1, // Divider
                            height: 24,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),



    );
  }
}
