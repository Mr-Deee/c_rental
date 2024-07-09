import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleInventory extends StatefulWidget {
  const VehicleInventory({super.key});

  @override
  State<VehicleInventory> createState() => _VehicleInventoryState();
}


class _VehicleInventoryState extends State<VehicleInventory> {


  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child('vehicles');
  final List<Map<dynamic, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }


  void _loadVehicles() {
    _databaseReference.onChildAdded.listen((event) {
      setState(() {
        final Map<dynamic, dynamic> vehicle = event.snapshot.value as Map<dynamic, dynamic>;
        vehicle['id'] = event.snapshot.key;
        _vehicles.add(vehicle);
      });
    });

    _databaseReference.onChildRemoved.listen((event) {
      setState(() {
        _vehicles.removeWhere((vehicle) => vehicle['id'] == event.snapshot.key);
      });
    });
  }

  void _deleteVehicle(String vehicleId) {
    _databaseReference.child(vehicleId).remove().then((_) {
      FirebaseStorage.instance.ref().child('vehicle_images/$vehicleId').delete();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(""),
      ),
      body:  ListView.builder(
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: vehicle['VehicleImages'][0],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Text(vehicle['model_name']),
            subtitle: Text(vehicle['price'].toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteVehicle(vehicle['id']),
            ),
          );
        },
      ),

    );
  }
}
