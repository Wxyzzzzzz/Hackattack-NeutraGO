import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RoutingScreen extends StatefulWidget {
  final List<dynamic> polylineCoordinates; // [[lat1, lng1], [lat2, lng2], ...]
  final LatLng destination;

  const RoutingScreen({
    super.key,
    required this.polylineCoordinates,
    required this.destination,
  });

  @override
  State<RoutingScreen> createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
    _drawRoute();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _initLocationTracking() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    _updatePosition(position);

    _positionStream = Geolocator.getPositionStream().listen((Position pos) {
      _updatePosition(pos);
    });
  }

  void _updatePosition(Position pos) {
    LatLng newPos = LatLng(pos.latitude, pos.longitude);
    setState(() {
      _currentPosition = newPos;

      _markers = {
        Marker(
          markerId: const MarkerId('user'),
          position: newPos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };

      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPos,
            zoom: 17,
            tilt: 70, // Key for 3D look
            bearing: pos.heading, // Face direction
          ),
        ));
      }
    });
  }

  void _drawRoute() {
    final routePoints =
        widget.polylineCoordinates.map((p) => LatLng(p[0], p[1])).toList();

    _polylines.add(Polyline(
      polylineId: const PolylineId("route"),
      points: routePoints,
      color: Colors.blue,
      width: 5,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 17,
                    tilt: 70,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                ),
                // ✅ Back Button
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: _buildInfoCard(),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard() {
    final distance = _calculateDistance();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distance: ${distance.toStringAsFixed(2)} km",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            "Route is being guided...",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  double _calculateDistance() {
    if (_currentPosition == null) return 0.0;
    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          widget.destination.latitude,
          widget.destination.longitude,
        ) /
        1000; // meters to km
  }
}
