import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('css/allReports');
  List<Map<String, String>> _complaints = [];
  bool _isLoading = true;

  late final Stream<DatabaseEvent> _complaintsStream;

  @override
  void initState() {
    super.initState();
    _complaintsStream = _databaseRef.onValue;
    _listenToComplaints();
  }

  void _listenToComplaints() {
    _complaintsStream.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final updatedComplaints = data.values
            .map<Map<String, String>>((e) => {
          "Username": e["Username"] as String,
          "message": e["message"] as String,
          "type": e["type"] as String,
        })
            .toList();

        setState(() {
          _complaints = updatedComplaints;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _complaints = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Complaints",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _complaints.isEmpty
          ? const Center(
        child: Text(
          "No complaints found.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _complaints.length,
        itemBuilder: (context, index) {
          final complaint = _complaints[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.assignment,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            complaint["type"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            complaint["Username"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.announcement,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          complaint["message"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
