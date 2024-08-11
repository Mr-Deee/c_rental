import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentandUsers extends StatefulWidget {
  const PaymentandUsers({super.key});

  @override
  State<PaymentandUsers> createState() => _PaymentandUsersState();
}

class _PaymentandUsersState extends State<PaymentandUsers> {
  bool showUsers = true;
  bool isLoading = true; // Add this variable to track loading state
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> payments = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    DatabaseEvent usersSnapshot = await _databaseReference.child('Clients').once();
    DatabaseEvent paymentsSnapshot = await _databaseReference.child('Rented').once();

    List<Map<String, dynamic>> usersData = [];
    List<Map<String, dynamic>> paymentsData = [];

    if (usersSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> usersMap = usersSnapshot.snapshot.value as Map<dynamic, dynamic>;
      usersMap.forEach((key, value) {
        usersData.add({
          'FirstName': value['FirstName'],
          'email': value['email'],
        });
      });
    }

    if (paymentsSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> paymentsMap = paymentsSnapshot.snapshot.value as Map<dynamic, dynamic>;
      paymentsMap.forEach((key, value) {
        paymentsData.add({
          'brand': value['brand'],
          'rentalDays': value['rentalDays'],
          'rentedAt': value['rentedAt'],
          'totalPrice': value['totalPrice'],
          'pricePerDay': value['pricePerDay'],
          'userName': value['userName'],
        });
      });
    }

    setState(() {
      users = usersData;
      payments = paymentsData;
      isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payments and Users'),
      ),
      body: Column(
        children: [
          CupertinoSegmentedControl<bool>(
            selectedColor: Colors.blue,
            children: {
              true: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Users'),
              ),
              false: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Payments'),
              ),
            },
            onValueChanged: (bool value) {
              setState(() {
                showUsers = value;
              });
            },
            groupValue: showUsers,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CupertinoActivityIndicator()) // Show dots loading indicator
                : showUsers
                ? _buildUserList()
                : _buildPaymentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]['FirstName']),
          subtitle: Text(users[index]['email']),
        );
      },
    );
  }

  Widget _buildPaymentList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(payments[index]['brand']),
                    Text('GHS${payments[index]['totalPrice'].toString()}'),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('GHS${payments[index]['pricePerDay']} a day'),
                    Text('By ${payments[index]['userName']}'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
