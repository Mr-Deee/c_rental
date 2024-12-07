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
//
//   double widthDevice = MediaQuery.of(context).size.width;
//   double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue), // Change back button color
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Add logout functionality
            },
            child: const Text(
              'logout',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(
                "assets/images/account.png"), // Replace with your image asset
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SectionTitle(title: 'ACCOUNT'),
                SettingsTile(
                  icon: Icons.person_outline,
                  title:'${userprovider?.firstname??""} ${ userprovider?.lastname??""}',
                  onTap: () {},
                ),

                SizedBox(height: 30),
                SettingsTile(
                  icon: Icons.email,
                  title: '${userprovider?.email??""}',
                  onTap: () {},
                ),
                SizedBox(height: 30),
                SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Unknown',
                  onTap: () {},
                ),
                SizedBox(height: 40),
                const SectionTitle(title: 'OTHER'),

                SettingsTile(
                  icon: Icons.question_mark,
                  title: 'About',
                  // trailing: Switch(
                  //   value: true,
                  //   onChanged: (value) {},
                  // ),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                SizedBox(height: 30),
                SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  onTap: () {
                    _showPrivacyDialog(context);
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      dense: true,
    );
  }

}
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, size: 50, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'About Benjis Rental',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Benjis Rental is a premier platform for vehicle rentals, offering a seamless and reliable experience. Our mission is to connect customers with quality rental services.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 50, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your privacy is important to us. Benjis Rental ensures that your data is protected and used responsibly. For more information, contact us.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }


