import 'package:flutter/material.dart';
import 'package:hackattack/screens/trip_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'trip_details_screen.dart';

class RunningModel extends StatefulWidget {
  final String userId;
  final DateTime timestamp;
  final LatLng currentLocation;
  final LatLng destination;

  const RunningModel({
    Key? key,
    required this.userId,
    required this.timestamp,
    required this.currentLocation,
    required this.destination,
  }) : super(key: key);

  @override
  _RunningModelState createState() => _RunningModelState();
}

class _RunningModelState extends State<RunningModel> {
  bool isLoading = true;
  dynamic resultData;

  @override
  void initState() {
    super.initState();
    fetchRecommendation();
  }

  Future<void> fetchRecommendation() async {
    // final url = Uri.parse("http://192.168.100.6:8000/recommend"); // replace with actual backend URL

    // print("URL:  ${url}");
    final url = Uri.parse("https://route-suggest.onrender.com/recommend");
    final body = {
      "user_id": "jAENInMkzS0KvYyVSyJA",
      "origin": "${widget.currentLocation.latitude}, ${widget.currentLocation.longitude}",
      "destination": "${widget.destination.latitude}, ${widget.destination.longitude}",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final recommendations = data['recommendations'] as List<dynamic>;

        setState(() {
          resultData = data;
          isLoading = false;
        });

        // Navigate to TripPlanningScreen with resultData
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              recommendations: recommendations,
              startLocation: widget.currentLocation,
              endLocation: widget.destination,
            ),
          ),
        );
      } else {
        throw Exception("Failed to get recommendation");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        resultData = {"error": "Failed to fetch data"};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: Text("Route Recommendation")),
    //   body: isLoading
    //       ? const Center(child: CircularProgressIndicator())
    //       : resultData == null || resultData['error'] != null
    //           ? Center(child: Text("Error: ${resultData['error']}"))
    //           : ListView.builder(
    //               itemCount: resultData['recommendations']?.length ?? 0,
    //               itemBuilder: (context, index) {
    //                 final route = resultData['recommendations'][index];
    //                 return Card(
    //                   margin: const EdgeInsets.all(12),
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(12),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text("Route ${route['rank']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    //                         ...List<Widget>.from(route['steps'].map<Widget>(
    //                           (step) => Text("• $step", style: TextStyle(fontSize: 14)),
    //                         )),
    //                         SizedBox(height: 8),
    //                         Text("Time: ${route['total_time']} min"),
    //                         Text("CO₂: ${route['total_emission']} g"),
    //                         Text("Score: ${route['score'].toStringAsFixed(3)}"),
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    // );
    return Scaffold(
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          // : const Text("Recommendation fetched."),
          : const CircularProgressIndicator(),
    ),
  );
  }
}
