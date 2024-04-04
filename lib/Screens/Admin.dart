import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AddVehicle.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  final locates = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size; //check the size of device
    final arg = (ModalRoute.of(context)?.settings.arguments ??
        <dynamic, dynamic>{}) as Map;
    return SafeArea(
      child: Scaffold(



        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: FadeInDown(
                delay: const Duration(milliseconds: 1000),
                child: SizedBox(
                  height: 180,
                  width: 400,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => Artisan_portfolio()),
                      //     (Route<dynamic> route) => true);
                    },
                    child: Card(
                      elevation: 8,
                      color: Colors.black,
                      shadowColor: Colors.black,
                      shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),

                          ),

                          side: BorderSide(

                              width: size.width, color: Colors.black54)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:28.0,left:7,right: 13),
                                child: Image.asset("assets/images/audi.png",width: 53,),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top:18.0),
                                child: Text("Benji's Admin",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white ),),
                              ),
                            ],
                          ),

                        Row(
                          children: [],
                        )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        height: 230,
                        width: 180,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => NewVehicle()),
                                (Route<dynamic> route) => true);
                          },
                          child: Card(
                            elevation: 8,
                            color: Colors.blue,
                            shadowColor: Colors.blueAccent,
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),

                                ),

                                side: BorderSide(
              
                                    width: size.width, color: Colors.black54)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:28.0),
                                  child: Image.asset("assets/images/audi.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 50, right: 30),
                                  child: Text('Add New Vehicle',
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FadeInDown(
                      delay: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        height: 230,
                        width: 180,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) => Artisan_portfolio()),
                            //     (Route<dynamic> route) => true);
                          },
                          child: Card(
                            elevation: 8,
                            color: Colors.white,
                            shadowColor: Colors.white,
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                side: BorderSide(

                                    width: size.width, color: Colors.white)),
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(top:28.0),
                                  child: Image.asset("assets/images/earnings.png",width: 120,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 10, right: 10),
                                  child: Text('Earnings',
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),





          ],
        ),
      ),
    );
  }

  void clear() {
    locates.clear();
  }
}
