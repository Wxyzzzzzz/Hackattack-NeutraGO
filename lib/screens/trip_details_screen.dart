// Assuming the recommendation result is passed to this screen
// You should define a model or use dynamic parsing based on your JSON structure

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'trip_planning_main.dart';
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
  // else {
  //   // Fallback: straight line
  //   _polylines.add(
  //     Polyline(
  //       polylineId: const PolylineId('fallback_route'),
  //       points: [widget.startLocation, widget.endLocation],
  //       color: Colors.grey,
  //       width: 3,
  //     ),
  //   );
  // }
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
            // Header
            Container(
              height: 70,
              color: const Color(0xFFF3F2E3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      // onPressed: () => Navigator.of(context).pop(),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => TripPlanningMainPage()),
                          (route) => false, // Remove all previous routes
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

            // Map
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  GoogleMap(
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
                ],
              ),
            ),

            // Details Section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                // padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
  //               // child: Column(
  //               //   crossAxisAlignment: CrossAxisAlignment.start,
  //                 // children: [
  //                 //   if (bestRoute != null) ...[
  //                 //     const Text('Best Route',
  //                 //         style: TextStyle(
  //                 //             fontSize: 18,
  //                 //             fontWeight: FontWeight.w700,
  //                 //             color: Color(0xFF1E1E1E))),
  //                 //     const SizedBox(height: 16),
  //                 //     _buildRouteCard(bestRoute),
  //                 //     const SizedBox(height: 24),
  //                 //   ],
  //                 child: SingleChildScrollView(
  //                 padding: const EdgeInsets.all(24),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     if (bestRoute != null) ...[
  //                       const Text('Best Route',
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.w700,
  //                               color: Color(0xFF1E1E1E))),
  //                       const SizedBox(height: 16),
  //                       _buildRouteCard(bestRoute),
  //                       const SizedBox(height: 24),
  //                     ],

  //                     if (otherRoutes.isNotEmpty) ...[
  //                       const Text('Other Routes',
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.w700,
  //                               color: Color(0xFF1E1E1E))),
  //                       const SizedBox(height: 16),
  //                       for (var route in otherRoutes) _buildSimpleRouteCard(route),
  //                     ]
  //                   ],
  //                 ),

  //                 //   if (otherRoutes.isNotEmpty) ...[
  //                 //     const Text('Other Routes',
  //                 //         style: TextStyle(
  //                 //             fontSize: 18,
  //                 //             fontWeight: FontWeight.w700,
  //                 //             color: Color(0xFF1E1E1E))),
  //                 //     const SizedBox(height: 16),
  //                 //     for (var route in otherRoutes) _buildSimpleRouteCard(route),
  //                 //   ]
  //                 // ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Route Switcher Buttons ===
                          if (widget.recommendations.length > 1) ...[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(widget.recommendations.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          currentRouteIndex = index;
                                          _setupMapData(); // Updates markers & polyline
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentRouteIndex == index
                                            ? Colors.deepPurple
                                            : Colors.grey,
                                      ),
                                      child: Text('Route ${index + 1}'),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // === Best Route Section ===
                          if (bestRoute != null) ...[
                            const Text('Best Route',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E1E1E))),
                            const SizedBox(height: 16),
                            _buildRouteCard(bestRoute),
                            const SizedBox(height: 24),
                          ],

                          // === Other Routes Section ===
                          if (otherRoutes.isNotEmpty) ...[
                            const Text('Other Routes',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E1E1E))),
                            const SizedBox(height: 16),
                            for (var route in otherRoutes) _buildSimpleRouteCard(route),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),


                // Fixed Go button at bottom center
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
                              // pathCoordinates: selectedRoute['polyline_points'],
                              // startLocation: widget.startLocation,
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
    );
  }

  Widget _buildRouteCard(dynamic route) {
    final steps = route['steps'] as List<dynamic>;
    final totalTime = route['total_time'];
    final totalEmission = route['total_emission'];

    // final transportModes = steps.take(2).map((s) {
    //   final mode = s.split('via').last.trim();
    //   return getTransportIcon(mode);
    // }).toList();
    final transportModes = <IconData>[];
    String? lastMode;
    for (var s in steps.take(2)) {
      final mode = s.split('via').last.trim();
      if (mode != lastMode) {
        transportModes.add(getTransportIcon(mode));
        lastMode = mode;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4D2161), width: 2),
      ),
      child: Row(
        children: [
          Column(
            children: transportModes
                .map((icon) => Column(
                      children: [Icon(icon, size: 24), const SizedBox(height: 4)],
                    ))
                .toList(),
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

  Widget _buildSimpleRouteCard(dynamic route) {
    final steps = route['steps'] as List<dynamic>;
    final totalTime = route['total_time'];
    final totalEmission = route['total_emission'];

    final transportModes = <IconData>[];
    String? lastMode;
    for (var s in steps.take(2)) {
      final mode = s.split('via').last.trim();
      if (mode != lastMode) {
        transportModes.add(getTransportIcon(mode));
        lastMode = mode;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Row(children: transportModes.map((icon) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, size: 24),
          )).toList()),
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
