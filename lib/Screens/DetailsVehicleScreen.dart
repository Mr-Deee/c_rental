import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../Constants/constants.dart';
import 'ReservationScreen.dart';

class DetailsVehicleScreen extends StatefulWidget {
  final String brand,
      modelYear,
      carburant,
      gearBox,
      emplacementPrise,
      imageVoiture;

  final double review;
  final int speed, price, idVoiture, power;
  late bool favorite;
  DetailsVehicleScreen(
      this.brand,
      this.modelYear,
      this.review,
      this.carburant,
      this.gearBox,
      this.speed,
      this.emplacementPrise,
      this.price,
      this.imageVoiture,
      this.idVoiture,
      this.favorite,
      this.power);

  @override
  _DetailsVehicleScreenState createState() => _DetailsVehicleScreenState();
}

class _DetailsVehicleScreenState extends State<DetailsVehicleScreen> {
  var db = FirebaseFirestore.instance;

  static IconData? iconFav;
  @override
  void initState() {
    setState(() {
      if (widget.favorite == false) {
        iconFav = Icons.favorite_outline;
      } else {
        iconFav = Icons.favorite_rounded;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0XFF78000a),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: widthDevice * 0.12),
                child: Text(
                  widget.price.toString() + " Dhs/day",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: heightDevice * 0.1,
                  width: widthDevice * 0.5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationScreen(
                                  widget.brand,
                                  widget.modelYear,
                                  widget.emplacementPrise,
                                  widget.price,
                                  widget.imageVoiture,
                                  widget.idVoiture,
                                  widget.review)));
                    },
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(25))),
                    ),
                  ),
                ),
              )
            ],
          ),
          height: 60,
          width: double.maxFinite,
        ),
      ),
      appBar: AppBar(backgroundColor: primaryColor, elevation: 0, actions: [
        Container(
          margin: EdgeInsets.only(right: widthDevice * 0.05),
          child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (widget.favorite == false) {
                  setState(() {
                    widget.favorite = true;
                    iconFav = Icons.favorite_rounded;
                  });
                } else {
                  setState(() {
                    widget.favorite = false;
                    iconFav = Icons.favorite_outline;
                  });
                }
                setfavorite();
              },
              child: Icon(iconFav, size: 35, color: Color(0XFFF01E1F))),
        ),
      ]),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Container(
            height: heightDevice * 0.4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: heightDevice * 0.01, left: widthDevice * 0.05),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.brand,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: heightDevice * 0.01),
                                child: Text(
                                  widget.modelYear,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ]),
                        Container(
                          margin: EdgeInsets.only(right: widthDevice * 0.05),
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(right: widthDevice * 0.02),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellowAccent,
                                  size: 22,
                                ),
                              ),
                              Text(
                                widget.review.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                Container(
                  child: Image.asset(
                    "assets/images/" + widget.imageVoiture.toString(),
                    height: heightDevice * 0.24,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: heightDevice * 0.04, left: widthDevice * 0.08),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Specifications",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: heightDevice * 0.02),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: widthDevice * 0.04,
                    ),
                    height: heightDevice * 0.17,
                    width: heightDevice * 0.22,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/fuelIcon.svg",
                              color: Colors.white,
                              width: widthDevice * 0.15,
                            ),
                            Text(
                              widget.carburant,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: widthDevice * 0.04,
                    ),
                    height: heightDevice * 0.17,
                    width: heightDevice * 0.22,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/speedIcon.svg",
                              color: Colors.white,
                              width: widthDevice * 0.15,
                            ),
                            Text(
                              widget.speed.toString() + "km/h",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: widthDevice * 0.04,
                    ),
                    height: heightDevice * 0.17,
                    width: heightDevice * 0.22,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/powerIcon.svg",
                              color: Colors.white,
                              width: widthDevice * 0.15,
                            ),
                            Text(
                              widget.power.toString() + " bhp",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: widthDevice * 0.04,
                    ),
                    height: heightDevice * 0.17,
                    width: heightDevice * 0.22,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              "assets/Icons/gearboxIcon.svg",
                              color: Colors.white,
                              width: widthDevice * 0.15,
                            ),
                            Text(
                              widget.gearBox,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: widthDevice * 0.04,
                    ),
                    height: heightDevice * 0.17,
                    width: heightDevice * 0.22,
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/Icons/carChair.svg",
                                    color: Colors.white,
                                    width: widthDevice * 0.1,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: widthDevice * 0.02),
                                    child: Text(
                                      "4 Sits",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/Icons/carDoor.svg",
                                    color: Colors.white,
                                    width: widthDevice * 0.08,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: widthDevice * 0.02),
                                    child: Text(
                                      "4 Doors",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ]),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: heightDevice * 0.02, left: widthDevice * 0.08),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: heightDevice * 0.01, left: widthDevice * 0.08),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/location.json',
                  width: 40,
                ),
                Container(
                  margin: EdgeInsets.only(left: widthDevice * 0.02),
                  child: Text(
                    widget.emplacementPrise,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void setfavorite() async {
    await db
        .collection("Vehicles")
        .where('idVoiture', isEqualTo: int.parse(widget.idVoiture.toString()))
        .get()
        .then((val) => val.docs.forEach((doc) => {
              doc.reference.update({
                'favorite': widget.favorite,
              })
            }));
  }
}
