import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../VehicleDetails.dart';

class Vehicle {
  final String id;
  final String name;
  final List<dynamic> imageUrl; // Using dynamic list for Firebase compatibility
  final double speed;
  final double pricePerDay;
  final String seats;
  final String vehiclenumber;
  final String transmission;
  // final String engineCapacity;
  final String location;

  Vehicle({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.speed,
    required this.pricePerDay,
    required this.seats,
    required this.vehiclenumber,
    required this.transmission,
    // required this.engineCapacity,
    required this.location,
  });

  factory Vehicle.fromMap(String id, Map<dynamic, dynamic> data) {
    return Vehicle(
      id: id,
      name: data['model_name'],
      imageUrl: data['VehicleImages'],
      speed: double.parse(data['speed'].toString()),
      pricePerDay: double.parse(data['price_per_day'].toString()),
      seats: data['seats'].toString(),
      vehiclenumber: data['vehicle_number'],
      transmission: data['Transmission'].toString(),
      // engineCapacity: data['EngineCapacity'].toString(),
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model_name': name,
      'VehicleImages': imageUrl,
      'speed': speed,
      'price_per_day': pricePerDay,
      'seats': seats,
      'vehicle_number': vehiclenumber,
      'Transmission': transmission,
      // 'engineCapacity': engineCapacity,
      'location': location,
    };
  }
}

class AllVehiclesPage extends StatefulWidget {
  @override
  _AllVehiclesPageState createState() => _AllVehiclesPageState();
}

class _AllVehiclesPageState extends State<AllVehiclesPage> {
  final DatabaseReference _vehiclesRef = FirebaseDatabase.instance.ref('vehicles');
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    try {
      final DataSnapshot snapshot = await _vehiclesRef.get();
      if (snapshot.exists) {
        final List<Vehicle> vehicles = [];
        for (var entry in snapshot.children) {
          final vehicleData = entry.value as Map<dynamic, dynamic>;
          vehicles.add(Vehicle.fromMap(entry.key ?? '', vehicleData));
        }
        setState(() {
          _vehicles = vehicles;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching vehicles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vehicles'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
          ? const Center(child: Text('No vehicles found.'))
          : ListView.builder(
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          final String vehicleImageUrl = vehicle.imageUrl.isNotEmpty
              ? vehicle.imageUrl[0] as String
              : 'https://example.com/default-image.png';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VehicleDetailsPage(
                    vehicleData: vehicle.toMap(),
                    vehicleId: vehicle.id,

                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0047AB), Color(0xFF82B1FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      vehicleImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              vehicle.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₵${vehicle.pricePerDay.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
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