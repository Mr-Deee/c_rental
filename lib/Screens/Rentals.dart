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
    fetchRentedVehicles();
  }

  void fetchRentedVehicles() {
    databaseReference.once().then((DatabaseEvent event) {
      List<Map<dynamic, dynamic>> tempList = [];
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;

      values?.forEach((key, value) {
        tempList.add(value);
      });

      setState(() {
        rentedList = tempList;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rented Cars'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
        itemCount: rentedList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: rentedList[index]['imageUrl'][0],
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rentedList[index]['brand'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${rentedList[index]['rentalDays'].toString()} days',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By: ${rentedList[index]['userName']}'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.lightGreenAccent),
                        onPressed: () {
                          // Add action here
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.redAccent),
                        onPressed: () {
                          // Add action here
                        },
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetails(vehicle: rentedList[index]),
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

  VehicleDetails({required this.vehicle});

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
            Text(
              'Client: ${vehicle['userName']}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Rental Days: ${vehicle['rentalDays']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Price: ${vehicle['totalPrice']}',
              style: TextStyle(fontSize: 16.0, color: Colors.green),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add action here
                  },
                  icon: Icon(Icons.check_circle, color: Colors.white),
                  label: Text('Approve'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add action here
                  },
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
