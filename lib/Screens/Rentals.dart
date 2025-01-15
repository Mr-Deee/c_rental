import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RentalVehicles extends StatefulWidget {
  const RentalVehicles({super.key});

  @override
  State<RentalVehicles> createState() => _RentalVehiclesState();
}

class _RentalVehiclesState extends State<RentalVehicles> {
  final databaseReference = FirebaseDatabase.instance.ref().child("Rented");
  List<Map<dynamic, dynamic>> rentedList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupRealtimeListener();
  }

  void _setupRealtimeListener() {
    databaseReference.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        List<Map<dynamic, dynamic>> tempList = [];
        final Map<dynamic, dynamic> values = event.snapshot.value as Map;

        values.forEach((key, value) {
          tempList.add(value as Map<dynamic, dynamic>);
        });

        setState(() {
          rentedList = tempList;
          isLoading = false;
        });
      } else {
        setState(() {
          rentedList = [];
          isLoading = false;
        });
      }
    });
  }

  void _showDeleteConfirmationDialog(Map<dynamic, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Vehicle"),
          content: Text("Are you sure you want to delete this vehicle?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteVehicle(vehicle);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteVehicle(Map<dynamic, dynamic> vehicle) {
    String? vehicleId = vehicle['id'];
    if (vehicleId != null && vehicleId.isNotEmpty) {
      databaseReference.child(vehicleId).remove().catchError((error) {
        debugPrint('Delete failed: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Rented Cars', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
        elevation: 23,
      ),
      body: isLoading
          ? Center(child: CupertinoActivityIndicator())
          : rentedList.isEmpty
          ? Center(
        child: Text(
          "No rented vehicles found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: rentedList.length,
        itemBuilder: (context, index) {
          final vehicle = rentedList[index];
          final documentId = vehicle['id']; // Firebase document ID


          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: vehicle['imageUrl']?[0] ?? 'https://via.placeholder.com/60',
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(vehicle['brand'] ?? 'Unknown brand', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${vehicle['rentalDays']?.toString() ?? 'N/A'} days', style: TextStyle(color: Colors.grey)),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By: ${vehicle['userName'] ?? 'Unknown user'}'),
                  Text('By: ${vehicle['ID'] ?? 'Unknown user'}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetails(
                      vehicle: vehicle,
                      onUpdate: () {},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class VehicleDetails extends StatelessWidget {
  final Map<dynamic, dynamic> vehicle;
  final Function onUpdate;

  VehicleDetails({required this.vehicle, required this.onUpdate});

  void sendEmail(String subject, String body) {
    // Implement your email sending logic here
  }
  void handleApprove() {
    // String subject = "Vehicle Approved";
    // String body = "Your rental vehicle ${vehicle['brand']} has been approved.";
    // sendEmail(subject, body);

    // Update the status in Firebase to "approved"
    var vehicleId = vehicle['vehicleId'];
    print("vecchid:$vehicleId");
    if (vehicleId != null && vehicleId.isNotEmpty) {
      final databaseReference = FirebaseDatabase.instance.ref().child("Rented");
      databaseReference.child(vehicleId).update({'status': 'approved'}).catchError((error) {
        debugPrint('Failed to update status: $error');
      });
    }
  }

  void handleReject(BuildContext context) {
    String subject = "Vehicle Rejected";
    String body = "Your rental vehicle ${vehicle['brand']} has been rejected.";
    sendEmail(subject, body);

    // Update the status in Firebase to "rejected"
    String? vehicleId = vehicle['id'];
    if (vehicleId != null && vehicleId.isNotEmpty) {
      final databaseReference = FirebaseDatabase.instance.ref().child("Rented");
      databaseReference.child(vehicleId).update({'status': 'rejected'}).catchError((error) {
        debugPrint('Failed to update status: $error');
      });
    }

    // Optionally, remove the vehicle if necessary
    _deleteVehicle(vehicle);
  }

  void _deleteVehicle(Map<dynamic, dynamic> vehicle) {
    String? vehicleId = vehicle['id'];
    if (vehicleId != null && vehicleId.isNotEmpty) {
      final databaseReference = FirebaseDatabase.instance.ref().child("Rented");
      databaseReference.child(vehicleId).remove().catchError((error) {
        debugPrint('Delete failed: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle['brand']),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: vehicle['imageUrl'][0],
              placeholder: (context, url) => CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text('Client: ${vehicle['userName']}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Rental Days: ${vehicle['rentalDays']}', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            Text('Total Price: ${vehicle['totalPrice']}', style: TextStyle(fontSize: 16.0, color: Colors.green)),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed:() {handleApprove();},
                  icon: Icon(Icons.check_circle, color: Colors.white),
                  label: Text('Approve'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () => handleReject(context),
                  icon: Icon(Icons.cancel, color: Colors.white),
                  label: Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
