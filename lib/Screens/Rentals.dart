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
    return Scaffold(
      appBar: AppBar(
        title: Text('Rented Cars'),
      ),
      body: ListView.builder(
        itemCount: RentedList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
               RentedList[index]['imageUrl'][0],

            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(RentedList[index]['brand']),
                Text('${RentedList[index]['rentalDays'].toString()} days')
              ],
            ),
            subtitle: Row(
              children: [
                Text('By:${RentedList[index]['userName']}'),
                IconButton(
                  icon: Icon(Icons.check_circle,color: Colors.lightGreenAccent,),
                  onPressed: (){},
                ),
                Text(RentedList[index]['rentalDays'].toString()),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableDetails(table: RentedList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TableDetails extends StatelessWidget {
  final Map<dynamic, dynamic> table;

  TableDetails({required this.table});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(table['brand']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              table['imageUrl'][0],
            ),
            SizedBox(height: 16.0),
            Text(
              'Client: ${table['userName']}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Days: ${table['rentalDays']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total: ${table['totalPrice']}',
              style: TextStyle(fontSize: 16.0),
            ),

            IconButton(
              icon: Icon(Icons.check_circle,color: Colors.lightGreenAccent,),
              onPressed: (){},
            ),


          ],
        ),
      ),
    );
  }

}
