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
  TextEditingController EngineCapacity = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController seat = TextEditingController();
  TextEditingController insideaccraprice = TextEditingController();
  TextEditingController outsideeaccraprice = TextEditingController();
  TextEditingController location = TextEditingController();
  String? selectedClassification;

  int _currentStep = 0;

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
    // Check required images
    if (images.any((image) => image == null)) {
      _showSnackBar('Please upload all required images.');
      return;
    }

    // Validate all fields at once
    final isAnyFieldEmpty = [
      modelname.text,
      transmission.text,
      vehiclemake.text,
      vColor.text,
      vehiclenumber.text,
      mobilenumber.text,
      EngineCapacity.text,
      speed.text,
      type.text,
      seat.text,
      insideaccraprice.text,
      outsideeaccraprice.text,
      location.text,
      selectedClassification
    ].any((field) => field == null || field.toString().trim().isEmpty);

    if (isAnyFieldEmpty) {
      _showSnackBar('Please fill all the required fields.');
      return;
    }

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
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

    try {
      // Upload images in parallel
      List<String?> imageUrls = await Future.wait(
        images.map((image) async {
          if (image != null) {
            return await _uploadImage(image);
          }
          return null;
        }),
      );

      // Prepare the vehicle data
      Map<String, dynamic> vehicleData = {
        'model_name': modelname.text,
        'Transmission': transmission.text,
        'vehicle_make': vehiclemake.text,
        'color': vColor.text,
        'vehicle_number': vehiclenumber.text,
        'mobile_number': mobilenumber.text,
        'EngineCapacity': EngineCapacity.text,
        'speed': speed.text,
        'type': type.text,
        'seats': seat.text,
        'outsideAccraprice_per_day': outsideeaccraprice.text,
        'insideAccraprice_per_day': insideaccraprice.text,
        'location': location.text,
        'classification': selectedClassification,
        'VehicleImages': imageUrls,
      };

      // Save data to Firebase
      await dbRef.push().set(vehicleData);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      _showSnackBar('Vehicle added successfully!');
      Navigator.of(context).pop();
    } catch (error) {
      // Close the loading dialog
      Navigator.of(context).pop();

      // Show error message
      _showSnackBar('Failed to add vehicle: $error');
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  Widget _imageSelectorContainer(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
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
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _imageSelectorContainer(0),
              _imageSelectorContainer(1),
              _imageSelectorContainer(2),
            ],
          ),
        );
      case 1:
        return Column(
          children: [
            _buildTextField('Model Name', Icons.car_rental_rounded, modelname),
            _buildTextField('Transmission', Icons.settings, transmission),
            _buildTextField('Vehicle Make', Icons.directions_car, vehiclemake),
            _buildTextField('Vehicle Color', Icons.color_lens, vColor),
            _buildTextField('Vehicle Number', Icons.numbers_rounded, vehiclenumber),
            _buildTextField('Speed', Icons.numbers_rounded, speed),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildTextField('Mobile Number', Icons.phone_android_rounded, mobilenumber),
            _buildTextField('EngineCapacity', Icons.oil_barrel, EngineCapacity),
            _buildTextField('Type', Icons.class_, type),
            _buildTextField('No. of Seats', Icons.chair, seat, isNumber: true),
            _buildDropdownField(),
            Row(
              children: [
                
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:18.0),
                      child: Text("Inside Accra",style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                    _buildTextField('Price/Day', Icons.attach_money, insideaccraprice, isNumber: true),
                  ],
                )),
                SizedBox(width: 12,),
                Expanded(child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top:18.0),
                      child: Text("Outside Accra",style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.bold)),
                    ),

                    _buildTextField('Price/Day', Icons.attach_money, outsideeaccraprice, isNumber: true),
                  ],
                )),
              ],
            ),
            _buildTextField('Your Location', Icons.pin_drop, location),
          ],
        );
      default:
        return Container();
    }
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
        child: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Color for active step
              onPrimary: Colors.white, // Text color for active step
              secondary: Colors.green, // Color for completed steps
              onSecondary: Colors.white, // Text color for completed steps
              surface: Colors.grey, // Color for inactive steps
              onSurface: Colors.black, // Text color for inactive steps
            ),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _saveVehicleData(context);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            steps: [
              Step(
                title: Text('Upload Images'),
                content: _buildStepContent(),
                isActive: _currentStep == 0,
                state: _currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
              ),
              Step(
                title: Text('Vehicle Details'),
                content: _buildStepContent(),
                isActive: _currentStep == 1,
                state: _currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
              ),
              Step(
                title: Text('Other Information'),
                content: _buildStepContent(),
                isActive: _currentStep == 2,
                state: _currentStep == 2
                    ? StepState.indexed
                    : StepState.complete,
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
      margin: EdgeInsets.only(top: 15),
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
        items: <String>['Featured', 'Affordable', 'General']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
