import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../Users.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _reportMessageController =
      TextEditingController();
  final List<String> _reportTypes = [
    "Technical Issue",
    "Account Issue",
    "Payment Issue",
    "Feedback",
    "Other"
  ];
  String? _selectedReportType;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String? _currentUserId;
  Map<String, dynamic>? _latestComplaint;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
      _fetchLatestComplaint();
    }
  }

  Future<void> _fetchLatestComplaint() async {
    if (_currentUserId == null) return;
    try {
      final snapshot = await _dbRef
          .child('Clients/$_currentUserId/css')
          .orderByKey()
          .limitToLast(1)
          .get();
      if (snapshot.exists) {
        final data = (snapshot.value as Map).values.first;
        if (data is Map) {
          setState(() {
            _latestComplaint = Map<String, dynamic>.from(data as Map);
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching latest complaint: $e");
    }
  }

  Future<void> _submitReport(Users userprovider) async {
    if (_selectedReportType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an issue type.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_reportMessageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the issue first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reportData = {
      "Username": userprovider.firstname,
      "PhoneNumber": userprovider.phone,
      "Email": userprovider.email,
      "type": _selectedReportType,
      "message": _reportMessageController.text,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      if (_currentUserId != null) {
        // Save under the `css` node
        final newRef = _dbRef.child('Clients/$_currentUserId/css').push();
        await newRef.set(reportData);

        // Save under the global `css` node
        await _dbRef.child('css/allReports').child(newRef.key!).set(reportData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _reportMessageController.clear();
        setState(() {
          _selectedReportType = null;
        });

        // Fetch the latest complaint
        _fetchLatestComplaint();
      }
    } catch (e) {
      debugPrint("Error saving report: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit the report. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<Users>(context).userInfo;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Report an Issue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Issue Type",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade900, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                // Remove default underline
                hint: const Text(
                  "Choose a type",
                  style: TextStyle(color: Colors.grey),
                ),
                value: _selectedReportType,
                items: _reportTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReportType = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Describe the Issue",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _reportMessageController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Type your message here...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitReport(userprovider!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Submit Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (_latestComplaint != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Latest Complaint",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 500,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type: ${_latestComplaint!['type']}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Message: ${_latestComplaint!['message']}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Timestamp: ${_latestComplaint!['timestamp']}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      "By Me",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            const Center(
              child: Text(
                "Thank you for helping us improve!",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
