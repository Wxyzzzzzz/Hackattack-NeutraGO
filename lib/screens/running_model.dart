import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class RunningModel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E3),
      appBar: AppBar(
        title: const Text('Searching...'),
        backgroundColor: const Color(0xFFF3F2E3),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Centered loading GIF (replace with your asset or network link)
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/loading.gif'), // <-- replace with your actual path
            ),
            const SizedBox(height: 20),
            const Text(
              'Generating best route for you...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}