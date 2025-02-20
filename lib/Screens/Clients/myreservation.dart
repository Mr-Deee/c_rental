import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RentedContainersPage extends StatefulWidget {
  @override
  _RentedContainersPageState createState() => _RentedContainersPageState();
}

class _RentedContainersPageState extends State<RentedContainersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Rented');
  List<Map<dynamic, dynamic>> _rentedData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRentedContainers();
  }

  Future<void> fetchRentedContainers() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final email = user.email;
      final snapshot = await _dbRef.once();
      final Map<dynamic, dynamic>? data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _rentedData = data.entries
              .map((entry) {
            return {
              'key': entry.key,
              ...entry.value as Map<dynamic, dynamic>,
            };
          })
              .where((entry) => entry['Email'] == email)
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _deleteRented(BuildContext context, String key) async {
    try {
      // Optimistically remove the item from the list
      setState(() {
        _rentedData.removeWhere((item) => item['key'] == key);
      });

      // Delete the item from the database
      await _dbRef.child(key).remove();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Rented vehicle deleted successfully.")),
      );

      // Fetch updated data in the background
      fetchRentedContainers();
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting vehicle: $e")),
      );

      // Reload data to ensure consistency
      fetchRentedContainers();
    }
  }

  void _showDetailsDialog(BuildContext context, Map<dynamic, dynamic> rented, String key) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        _deleteRented(context, key);
                      },
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                if (rented['imageUrl'] != null &&
                    rented['imageUrl'] is List &&
                    rented['imageUrl'].isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      rented['imageUrl'][0],
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16.0),
                Text(
                  rented['brand'] ?? 'Unknown Brand',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text("Transmission: ${rented['Transmission'] ?? 'N/A'}"),
                Text("Engine Capacity: ${rented['EngineCap'] ?? 'N/A'}"),
                Text("Seats: ${rented['Seats'] ?? 'N/A'}"),
                Text("Rental Days: ${rented['rentalDays'] ?? 'N/A'}"),
                Text("Total Price: GHS ${rented['totalPrice'] ?? '0.00'}"),
                Text("Rented At: ${rented['rentedAt'] ?? 'N/A'}"),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rented Vehicles'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _rentedData.isEmpty
          ? Center(child: Text('No rented vehicles found.'))
          : ListView.builder(
        itemCount: _rentedData.length,
        itemBuilder: (context, index) {
          final rented = _rentedData[index];
          return RentedContainerCard(
            rented: rented,
            onDelete: _deleteRented,
            onDetails: _showDetailsDialog,
          );
        },
      ),
    );
  }
}

class RentedContainerCard extends StatelessWidget {
  final Map<dynamic, dynamic> rented;
  final Future<void> Function(BuildContext, String) onDelete;
  final void Function(BuildContext, Map<dynamic, dynamic>, String) onDetails;

  const RentedContainerCard({
    Key? key,
    required this.rented,
    required this.onDelete,
    required this.onDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApproved = rented['status'] == 'approved';

    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rented['imageUrl'] != null &&
              rented['imageUrl'] is List &&
              rented['imageUrl'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                rented['imageUrl'][0],
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rented['brand'] ?? 'Unknown Brand',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Price: GHS ${rented['totalPrice'] ?? '0.00'}",
                //       style: TextStyle(
                //         fontSize: 16.0,
                //         color: Colors.green,
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         onDetails(context, rented, rented['key']);
                //       },
                //       child: Text(
                //         "Details",
                //         style: TextStyle(color: Colors.blue),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.pending,
                          color: isApproved ? Colors.green : Colors.orange,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          isApproved ? 'Approved' : 'Pending',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: isApproved ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    // ElevatedButton(
                    //   onPressed: () => _onMakePayment(context, rented),
                    //   child: Text("Make Payment", style: TextStyle(color: Colors.white)),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMakePayment(BuildContext context, Map<dynamic, dynamic> rented) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment feature coming soon for ${rented['brand'] ?? 'this vehicle'}!"),
      ),
    );
  }
}
