import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vehicleData;

  VehicleDetailsPage({required this.vehicleData});

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF0047AB),
      appBar: AppBar(
        backgroundColor: Color(0xFF0047AB),
        title: Text(
          widget.vehicleData['model_name'],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.vehicleData['VehicleImages'][1],
                height: 200,
                width: 200,
              ),
            ),

            SizedBox(height: 10),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDetailRow(
                        Image.asset('assets/images/ENGINE.png',
                            width: 74, height: 74),
                        'Model Number',
                        widget.vehicleData['model_number'].toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/seats.png',
                            width: 74, height: 74),
                        'Number of Seats',
                        widget.vehicleData['seats'].toString()),
                    _buildDetailRow(
                        Image.asset('assets/images/SPEEDO.png',
                            width: 74, height: 74),
                        'Number of Seats',
                        widget.vehicleData['speed'].toString()),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                _buildDetailRow(
                    Image.asset('assets/images/PLATE.png', width: 74, height: 74),
                    'Plate Number',
                    widget.vehicleData['vehicle_number'].toString()),
                _buildDetailRow(
                    Image.asset('assets/images/PLATE.png', width: 74, height: 74),
                    'Plate Number',
                    widget.vehicleData['vehicle_number'].toString()),
              ],
            ),
            // Add more details as needed

            Container(
              height: 123,
              decoration: BoxDecoration(
                  color: Color(0xFF0047AB),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 18, right: 18),
                        child: Container(
                          height: 52,
                          width: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                          ),
                          child: Center(
                              child: Text(
                            "Benjis",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "lOCATION",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("lOCATION"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_view_day,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                "Mon - Sun",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            // Add some space between the icon and text
                            Text(
                              "(233)503026630",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ), // Second icon
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 22,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                   Center(
                      child: Row(children: [
                          Text("\$${ widget.vehicleData['price']}/day",style: TextStyle(color: Colors.black,fontSize: 34),),

                        ],
                      )),
                Row(

                  children: [

                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF0047AB),
                          borderRadius: BorderRadius.circular(10)

                      ),
                      height: 53,
                      width: 120,
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Rent Now",style: TextStyle(color: Colors.white),),
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ],
                )
            ]),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(Image image, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 135,
        width: 126,
        decoration: BoxDecoration(
            color: Color(0xFF0047AB), borderRadius: BorderRadius.circular(23)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              SizedBox(width: 10),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: image, // Using the passed image widget
                  ),

                  // Text(
                  //   '$title: ',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
