// Assuming the recommendation result is passed to this screen
// You should define a model or use dynamic parsing based on your JSON structure

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackattack/main_navigation_page.dart';

import 'trip_planner.dart';
import 'routing_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final List<dynamic> recommendations;
  final LatLng startLocation;
  final LatLng endLocation;

  const TripDetailsScreen({
    Key? key,
    required this.recommendations,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  int currentRouteIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupMapData();
  }

  // Color _getColorForMode(String mode) {
  //     switch (mode.toLowerCase()) {
  //       case 'walking':
  //         return Colors.grey;
  //       case 'bicycling':
  //         return Colors.green;
  //       case 'driving':
  //         return Colors.blue;
  //       case 'transit':
  //         return Colors.orange;
  //       default:
  //         return Colors.black;
  //     }
  //   }

  void _setupMapData() {
    _markers.clear();
    _polylines.clear();

    _markers.addAll([
      Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: widget.endLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);

  // Draw polyline from recommended route
  if (widget.recommendations.isNotEmpty) {
    final recommendation = widget.recommendations[currentRouteIndex]; // top-ranked route
    final List<dynamic> coords = recommendation['polyline_points'];

    final List<LatLng> polylinePoints = coords.map<LatLng>((coord) {
      return LatLng(coord[0], coord[1]); // Convert each [lat, lng] to LatLng
    }).toList();

    _polylines.add(
      Polyline(
        polylineId: PolylineId('route_$currentRouteIndex'),
        points: polylinePoints,
        color: Colors.blueAccent,
        width: 3,
      ),
    );
  } 
  //   final steps = recommendation['steps'] as List<dynamic>;

  //   for (int i = 0; i < steps.length; i++) {
  //     final step = steps[i];
  //     final mode = step['mode'].toString().toLowerCase(); // e.g., "walking", "transit", "driving"

  //     final coords = step['polyline_points']; // e.g., [[lat, lng], [lat, lng], ...]
  //     if (coords == null || coords.length < 2) continue;

  //     final List<LatLng> polylinePoints = coords.map<LatLng>((coord) {
  //       return LatLng(coord[0], coord[1]);
  //     }).toList();

  //     _polylines.add(
  //       Polyline(
  //         polylineId: PolylineId('route_${currentRouteIndex}_step_$i'),
  //         points: polylinePoints,
  //         color: _getColorForMode(mode),
  //         width: 4,
  //       ),
  //     );
  //   }
  // }
  }

  LatLngBounds _createBoundsFromPoints(List<dynamic> points) {
    final latLngList = points.map((e) => LatLng(e[0], e[1])).toList();

    double south = latLngList.first.latitude;
    double north = latLngList.first.latitude;
    double west = latLngList.first.longitude;
    double east = latLngList.first.longitude;

    for (var point in latLngList) {
      south = point.latitude < south ? point.latitude : south;
      north = point.latitude > north ? point.latitude : north;
      west = point.longitude < west ? point.longitude : west;
      east = point.longitude > east ? point.longitude : east;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;

      // Zoom into current route
      final polylinePoints = widget.recommendations[currentRouteIndex]['polyline_points'];
      if (polylinePoints.isNotEmpty) {
        final bounds = _createBoundsFromPoints(polylinePoints);
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }

  //   // Collect all coordinates across all steps of the selected route
  //   final route = widget.recommendations[currentRouteIndex];
  //   final steps = route['steps'] as List<dynamic>;

  //   List<LatLng> allPoints = [];

  //   for (final step in steps) {
  //     final coords = step['polyline_points'] as List<dynamic>;
  //     if (coords.isNotEmpty) {
  //       final stepPoints = coords.map((c) => LatLng(c[0], c[1])).toList();
  //       allPoints.addAll(stepPoints);
  //     }
  //   }

  //   if (allPoints.isNotEmpty) {
  //     final bounds = _createBoundsFromPoints(allPoints);
  //     controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  //   }
  // }

  IconData getTransportIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'driving':
        return Icons.directions_car;
      case 'walking':
        return Icons.directions_walk;
      case 'transit':
        return Icons.directions_bus;
      case 'bicycling':
        return Icons.directions_bike;
      default:
        return Icons.directions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestRoute = widget.recommendations.isNotEmpty ? widget.recommendations[0] : null;
    final otherRoutes = widget.recommendations.length > 1
        ? widget.recommendations.sublist(1)
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === Header ===
            Container(
              height: 70,
              color: const Color(0xFFF3F2E3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainNavigationPage(initialIndex: 1)),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF153462), size: 28),
                    ),
                    const Expanded(
                      child: Text(
                        'Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF153462),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
            ),

            // === Map Section ===
            Expanded(
              flex: 2,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.startLocation,
                  zoom: 14.0,
                ),
                markers: _markers,
                polylines: _polylines,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            // === Stack for Details + Fixed Button ===
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // === Scrollable Details Section ===
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bestRoute != null) ...[
                            const Text(
                              'Best Route',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentRouteIndex = 0;
                                  _setupMapData();
                                });
                              },
                              child: _buildRouteCard(
                                bestRoute,
                                isSelected: currentRouteIndex == 0,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (otherRoutes.isNotEmpty) ...[
                            const Text(
                              'Other Routes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 16),
                            for (int i = 0; i < otherRoutes.length; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentRouteIndex = i + 1;
                                    _setupMapData();
                                  });
                                },
                                child: _buildSimpleRouteCard(
                                  otherRoutes[i],
                                  isSelected: currentRouteIndex == i + 1,
                                ),
                              ),
                            const SizedBox(height: 80), // space for the button
                          ],
                        ],
                      ),
                    ),
                  ),

                  // === Fixed "Go" Button ===
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final selectedRoute = widget.recommendations[currentRouteIndex];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutingScreen(
                                polylineCoordinates: selectedRoute['polyline_points'],
                                destination: widget.endLocation,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text("Go"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRouteCard(dynamic route, {bool isSelected = false}) {
    final steps = route['steps'] as List<dynamic>;
    final totalTime = route['total_time'];
    final totalEmission = route['total_emission'];

    final List<Widget> transportWidgets = [];
    String? lastMode;
    bool isFirst = true;

    for (var s in steps) {
      final mode = s.split('via').last.trim();
      if (mode != lastMode) {
        if (!isFirst) {
          transportWidgets.add(const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('>', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ));
        }

        transportWidgets.add(Icon(getTransportIcon(mode), size: 24));
        lastMode = mode;
        isFirst = false;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: const Color(0xFFD9D9D9),
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF22866E) : const Color(0xFFD9D9D9),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Row(
            children: transportWidgets
          ),
          const Spacer(),
          Column(
            children: [
              Text('${totalTime.toStringAsFixed(0)} mins',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              Text('Saves ${totalEmission.toStringAsFixed(0)}g CO₂',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSimpleRouteCard(dynamic route, {bool isSelected = false}) {
    final steps = route['steps'] as List<dynamic>;
    final totalTime = route['total_time'];
    final totalEmission = route['total_emission'];

    final List<Widget> transportWidgets = [];
    String? lastMode;
    bool isFirst = true;

    for (var s in steps) {
      final mode = s.split('via').last.trim();
      if (mode != lastMode) {
        if (!isFirst) {
          transportWidgets.add(const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('>', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ));
        }

        transportWidgets.add(Icon(getTransportIcon(mode), size: 24));
        lastMode = mode;
        isFirst = false;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        // color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF22866E) : const Color(0xFFD9D9D9),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Row(
            children: transportWidgets
          ),
          const Spacer(),
          Column(
            children: [
              Text('${totalTime.toStringAsFixed(0)} mins',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              Text('${totalEmission.toStringAsFixed(0)}g CO₂',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
