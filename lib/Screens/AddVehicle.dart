import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Admin.dart';
import 'SignUpScreen.dart';

class NewVehicle extends StatefulWidget {
  const NewVehicle({Key? key}) : super(key: key);

  @override
  State<NewVehicle> createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final modelname = TextEditingController();
  final vehiclemake = TextEditingController();
  final transmission = TextEditingController();
  final vColor= TextEditingController();
  final vehiclenumber = TextEditingController();
  final mobilenumber = TextEditingController();
  final status = TextEditingController();
  final type = TextEditingController();
  final price = TextEditingController();
  final seat = TextEditingController();
  final location = TextEditingController();
  String? selectedClassification;

  List<File?> _images = [];

  List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
        title: Text(
          'Add Vehicle ',
          style: TextStyle(
            fontFamily: 'Bowlby',
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.aspectRatio * 70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: <Widget>[
                // Your existing text fields...
                // Add image picker button
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _imageSelectorContainer(0),
                      _imageSelectorContainer(1),
                      _imageSelectorContainer(2),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: modelname,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Model Name',
                      suffixIcon: Icon(Icons.car_rental_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: transmission,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Transmission',
                      suffixIcon: Icon(Icons.car_rental_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: vehiclemake,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Make',
                      suffixIcon: Icon(Icons.car_rental_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: vColor,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Color',
                      suffixIcon: Icon(Icons.car_rental_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: vehiclenumber,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Vehicle Number',
                      suffixIcon: Icon(Icons.numbers_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: mobilenumber,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      suffixIcon: Icon(Icons.phone_android_rounded),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: type,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      suffixIcon: Icon(Icons.select_all_sharp),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                    Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: seat,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'No.of Seats',
                      suffixIcon: Icon(Icons.chair),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: DropdownButtonFormField<String>(
                    value: selectedClassification, // Selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedClassification = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Classification',
                      suffixIcon: Icon(Icons.flight_class),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.blue),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                    items: <String>['Featured', 'affordable', 'regular'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      //labelText: 'Price',
                      hintText: 'Price/Day',
                      prefixIcon: Icon(Icons.attach_money),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: location,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Your Location',
                      suffixIcon: Icon(Icons.pin_drop),
                      floatingLabelStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.black)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            (BorderSide(width: 1.0, color: Colors.blue)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     _pickImage(index);
                //   },
                //   child: Text('Select Image'),
                // ),
                SizedBox(height: 10),
                // Display selected images

                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: ElevatedButton(
                    onPressed: () {
                      addvehicle();
                      // addVehicledb(_imageUrls);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'DelaGothic',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      enableFeedback: false,
                      elevation: 20,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _imageSelectorContainer(int index) {
    return GestureDetector(
      onTap: () {
        _pickImage(index);
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _images.length > index && _images[index] != null
              ? Image.file(_images[index]!)
              : Icon(Icons.add),
        ),
      ),
    );
  }

  void _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (_images.length < 4) {
          _images.add(File(pickedFile.path));
        } else {
          // Show error message or limit reached message
          // You can use a SnackBar for this purpose
        }
      });
    }
  }
  void addvehicle() async {
    // Upload images to Firebase Storage
    for (var imageFile in _images) {
      if (imageFile != null) {
        final storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(
                  'vehicle_images/${modelname.text}/${DateTime.now().millisecondsSinceEpoch}.jpg',
                );
        await storageRef.putFile(imageFile);
        final downloadURL = await storageRef.getDownloadURL();

          _imageUrls.add(downloadURL); // Add download URL to the list

      }
      addVehicledb();
    }
  }

  void addVehicledb() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6.0,
                            ),
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            SizedBox(
                              width: 26.0,
                            ),
                            Text("Adding vehicle,please wait...")
                          ],
                        ),
                      ))));
        });
    _database.child('vehicles').push().set({
      'VehicleImages': _imageUrls,
      'model_name': modelname.text,
      'Transmission': transmission.text,
      'vehicle_make': vehiclemake.text,
      'vehicleColor': vColor.text,
      'vehicle_number': vehiclenumber.text,
      'mobile_number': mobilenumber.text,
      'status':selectedClassification!,
      'type': type.text,
      'seats': int.tryParse(seat.text) ?? 0,
      'price': double.tryParse(price.text) ?? 0.0,
      'location': location.text,

    }).then((_) {

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Admin()),
              (Route<dynamic> route) => false);
      displayToast("Added Successfully ", context);
    }).catchError((error) {
      // Handle errors
      print("Failed to add vehicle: $error");
    });
  }
}
displayToast(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}