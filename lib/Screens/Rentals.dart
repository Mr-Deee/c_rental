import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class RentalVehicles extends StatefulWidget {
  const RentalVehicles({super.key});

  @override
  State<RentalVehicles> createState() => _RentalVehiclesState();
}

class _RentalVehiclesState extends State<RentalVehicles> {

  final databaseReference = FirebaseDatabase.instance.ref().child("Rented");
  List<Map<dynamic, dynamic>> RentedList = [];

  @override
  void initState() {
    super.initState();
    fetchRentedTables();
  }

  void fetchRentedTables() {
    databaseReference.once().then((DatabaseEvent event) {
      List<Map<dynamic, dynamic>> tempList = [];
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;

      values?.forEach((key, value) {
        tempList.add(value);
      });
      setState(() {
        RentedList = tempList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
