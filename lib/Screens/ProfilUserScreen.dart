import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/constants.dart';
import '../Users.dart';

class ProfilUserScreen extends StatefulWidget {
  // final String? firstName, lastName, phoneNumber, gender;
  // final String? userEmail, userId;

  ProfilUserScreen();

  // this.userEmail, this.userId, this.firstName, this.lastName,
  // this.phoneNumber, this.gender);

  @override
  _ProfilUserScreenState createState() => _ProfilUserScreenState();
}

class _ProfilUserScreenState extends State<ProfilUserScreen> {
  var db = FirebaseFirestore.instance;

  // late var _emailController =
  //     TextEditingController(text: widget.userEmail.toString());
  // late var _firstNameController =
  //     TextEditingController(text: widget.firstName.toString());
  // late var _lastNameController =
  //     TextEditingController(text: widget.lastName.toString());
  // late var _phoneNumberController =
  //     TextEditingController(text: widget.phoneNumber.toString());

  late String genderValue = "male";
  var items = ["male", "female"];

  final GlobalKey<FormState> _editProfilForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;

    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: heightDevice * 0.3,
              decoration: BoxDecoration(color: Color(0xFF0047AB)),
              child: Container(
                margin: EdgeInsets.only(bottom: heightDevice * 0.08),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: widthDevice * 0.05),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: widthDevice * 0.05),
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: widthDevice * 0.02),
                      child: TextButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: heightDevice * 0.20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Container(
                width: widthDevice,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF0047AB),
                                offset: Offset(1, 2),
                                blurRadius: 3
                            )
                          ]),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/account.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:Color(0xFF0047AB),
                              spreadRadius: 0.2,
                            offset: Offset(1, 2),
                            blurRadius: 3
                          )
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      //      width: widthDevice * 0.8,
                                      child: Text(
                                          "${userprovider?.firstname}  ${userprovider?.lastname}"
                                          //controller: _firstNameController,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Container(
                                  // margin: EdgeInsets.only(
                                  //     left: widthDevice * 0.1, top: heightDevice * 0.04),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.email),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  //width: widthDevice * 0.8,
                                  child: Text("${userprovider?.phone}"
                                      //controller: _firstNameController,
                                      ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Container(
                                  // margin: EdgeInsets.only(
                                  //     left: widthDevice * 0.1, top: heightDevice * 0.04),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.phone),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  // margin: EdgeInsets.only(
                                  //     left: widthDevice * 0.1,
                                  //     top: heightDevice * 0.04),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text("${userprovider?.email}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      )),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
//
// void editProfil() async {
//   await db.collection("Users").doc(widget.userId).set({
//     "firstName": _firstNameController.text,
//     "lastName": _lastNameController.text,
//     "email": _emailController.text,
//     "phoneNumber": _phoneNumberController.text,
//     "gender": genderValue,
//   }).then((value) {
//     // Navigator.pushAndRemoveUntil(
//     //     context,
//     //     MaterialPageRoute(builder: (context) => VehicleScreen()),
//     //     (_) => false);
//   });
// }
}
