import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final ImagePicker _picker = ImagePicker();
  List<File?> images = [null, null, null];
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('vehicles');

  // Controllers for form fields
  TextEditingController modelname = TextEditingController();
  TextEditingController transmission = TextEditingController();
  TextEditingController vehiclemake = TextEditingController();
  TextEditingController vColor = TextEditingController();
  TextEditingController vehiclenumber = TextEditingController();
  TextEditingController speed = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController seat = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController location = TextEditingController();
  String? selectedClassification;

  // Function to pick images
  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        images[index] = File(image.path);
      });
    }
  }

  // Function to upload images to Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  // Function to save vehicle data along with image URLs
  Future<void> _saveVehicleData(BuildContext context) async {
    // Show the progress indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Saving vehicle data..."),
            ],
          ),
        );
      },
    );

    List<String?> imageUrls = [];
    for (var image in images) {
      if (image != null) {
        String? url = await _uploadImage(image);
        imageUrls.add(url);
      }
    }

    Map<String, dynamic> vehicleData = {
      'model_name': modelname.text,
      'Transmission': transmission.text,
      'vehicle_make': vehiclemake.text,
      'color': vColor.text,
      'vehicle_number': vehiclenumber.text,
      'mobile_number': mobilenumber.text,
      'speed': speed.text,
      'type': type.text,
      'seats': seat.text,
      'price_per_day': price.text,
      'location': location.text,
      'classification': selectedClassification,
      'VehicleImages': imageUrls,
    };

    try {
      await dbRef.push().set(vehicleData);
      Navigator.of(context).pop(); // Close the progress dialog

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vehicle added successfully!'),
      ));
      Navigator.of(context).pop(); // Navigate back to the previous page
    } catch (error) {
      Navigator.of(context).pop(); // Close the progress dialog

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add vehicle: $error'),
      ));
    }
  }

  // Image selector container with styling
  Widget _imageSelectorContainer(int index) {
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(width: 2, color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(15),
        ),
        child: images[index] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(images[index]!, fit: BoxFit.cover),
              )
            : Icon(Icons.add_a_photo, size: 40, color: Colors.blueAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Add Vehicle',
          style: TextStyle(
            fontFamily: 'Bowlby',
            color: Colors.blue,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  // Image pickers
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
                  // Other input fields
                  _buildTextField(
                      'Model Name', Icons.car_rental_rounded, modelname),
                  _buildTextField('Transmission', Icons.settings, transmission),
                  _buildTextField(
                      'Vehicle Make', Icons.directions_car, vehiclemake),
                  _buildTextField('Vehicle Color', Icons.color_lens, vColor),
                  _buildTextField('Vehicle Number', Icons.numbers_rounded, vehiclenumber),
                  _buildTextField('Speed', Icons.numbers_rounded, speed),
                  _buildTextField('Mobile Number', Icons.phone_android_rounded,
                      mobilenumber),
                  _buildTextField('Type', Icons.class_, type),
                  _buildTextField('No. of Seats', Icons.chair, seat,
                      isNumber: true),
                  _buildDropdownField(),
                  _buildTextField('Price/Day', Icons.attach_money, price,
                      isNumber: true),
                  _buildTextField('Your Location', Icons.pin_drop, location),
                  // Submit button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                    await  _saveVehicleData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Add Vehicle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isNumber = false}) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon, color: Colors.blueAccent),
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: DropdownButtonFormField<String>(
        value: selectedClassification,
        onChanged: (String? newValue) {
          setState(() {
            selectedClassification = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Classification',
          suffixIcon: Icon(Icons.flight_class, color: Colors.blueAccent),
          labelStyle: TextStyle(color: Colors.blueAccent),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
        ),
        items: <String>['Featured', 'Affordable', 'Regular']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.blueAccent)),
          );
        }).toList(),
      ),
    );
  }
}
