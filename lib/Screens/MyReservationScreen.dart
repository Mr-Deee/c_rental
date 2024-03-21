import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constants/constants.dart';
import 'DetailsMyReservations.dart';

class MyReservationsScreen extends StatefulWidget {
  final String? userId;
  MyReservationsScreen(this.userId);

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  late Stream<QuerySnapshot> _reservationStream = FirebaseFirestore.instance
      .collection('Reservations')
      .where('idUser', isEqualTo: widget.userId)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0XFFF3F3F4),
      appBar: AppBar(
        title: Text("My Reservations"),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reservationStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              DateTime dt = (data['dateReservation'] as Timestamp).toDate();
              String formattedDateRes = DateFormat('dd/MM/yyyy').format(dt);
              DateTime dr = (data['dateRetour'] as Timestamp).toDate();
              String formattedDateRet = DateFormat('dd/MM/yyyy').format(dr);
              return Container(
                margin: EdgeInsets.only(
                    top: heightDevice * 0.01,
                    left: widthDevice * 0.04,
                    bottom: heightDevice * 0.01,
                    right: widthDevice * 0.04),
                height: heightDevice * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0.5,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/" + data['imageVoitureR'].toString(),
                            height: heightDevice * 0.11,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: heightDevice * 0.02,
                            ),
                            child: Text(
                              formattedDateRes,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: widthDevice * 0.04,
                          top: heightDevice * 0.02495,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: widthDevice * 0.01,
                              ),
                              child: Column(children: [
                                Text(
                                  data['brandR'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                                Text(
                                  data['modelYearR'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ),
                              ]),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  height: heightDevice * 0.06,
                                  width: widthDevice * 0.385,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsMyReservations(
                                                    data['brandR'],
                                                    data['modelYearR'],
                                                    data['imageVoitureR'],
                                                    formattedDateRes,
                                                    formattedDateRet,
                                                    data['approved'],
                                                    data['montantTotal'],
                                                    data['paymentMethod'],
                                                    data['reviewR'],
                                                  )));
                                    },
                                    child: Text(
                                      "Check Status",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: data['approved']
                                          ? Colors.green
                                          : Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
