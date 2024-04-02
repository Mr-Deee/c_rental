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


        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => NewVehicle()));
        //   },
        //   label: Text(
        //     'ADD VEHICLE',
        //     style: TextStyle(
        //         fontStyle: FontStyle.italic,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 15),
        //   ),
        //   icon: Icon(
        //     Icons.add_rounded,
        //     size: 30,
        //   ),
        //   elevation: 80,
        //   splashColor: Colors.black,
        //   backgroundColor: Colors.blue,
        //   foregroundColor: Colors.black,
        // ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.14,
              child: TextField(
                keyboardType: TextInputType.text,
                controller: locates,
                decoration: InputDecoration(
                    hintText: 'Your Preffered Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: (BorderSide(width: 1.0, color: Colors.blue)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: (BorderSide(width: 1.0, color: Colors.blue)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.filter_list_rounded)),
                    suffixIcon: IconButton(
                        onPressed: clear, icon: Icon(Icons.pin_drop_rounded))),
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
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) => Artisan_portfolio()),
                            //     (Route<dynamic> route) => true);
                          },
                          child: Card(
                            elevation: 8,
                            color: Colors.blue,
                            shadowColor: Colors.black38,
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
                            shadowColor: Colors.black38,
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                side: BorderSide(

                                    width: size.width, color: Colors.white24)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, left: 10, right: 10),
                                  child: Text('Earnings',
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                ),
                                Icon(
                                  Icons.monetization_on_rounded,
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




            // MyCard(
            //   modelname: arg['modelname'],
            //   price: arg['price'],
            //   type: arg['type'],
            //   mobilenumber: arg['mobilenumber'],
            //   seat: arg['seat'],
            //   vehiclenumber: arg['vehiclenumber'],
            //   location: arg['location'],
            // ),
          ],
        ),
      ),
    );
  }

  void clear() {
    locates.clear();
  }
}
