import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({Key? key}) : super(key: key);

  @override
  State<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  String _selectedDestinationType = '';
  
  
  // Example initial position (Penang, Malaysia)
  final LatLng _center = const LatLng(5.4164, 100.3327);

  @override
  void initState() {
    super.initState();
    _addCurrentLocationMarker();
  }

  void _addCurrentLocationMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _center,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectDestinationType(String type) {
    setState(() {
      _selectedDestinationType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            // Container(
            //   height: 60,
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     // children: [
            //       // IconButton(
            //       //   icon: const Icon(Icons.arrow_back, color: Color(0xFF153462)),
            //       //   onPressed: () => Navigator.pop(context),
            //       // ),
            //       const Expanded(
            //         child: Center(
            //           child: Text(
            //             'Trip Planning',
            //             style: TextStyle(
            //               color: Color(0xFF153462),
            //               fontSize: 20,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //       ),
            //       // const SizedBox(width: 48), // Balance the back button
            //     // ],
            //   ),
            // ),
            Container(
              height: 60,
              alignment: Alignment.center,
              color: const Color(0xFFF3F2E3),
              child: const Text(
                'Trip Planning',
                style: TextStyle(
                  color: Color(0xFF153462),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
                        
            // Blue line under header
            Container(
              height: 3,
              color: const Color(0xFF153462),
            ),
            
            // Map Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: _markers,
                    mapType: MapType.normal,
                  ),
                  // Current location marker indicator
                  const Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      'UNION',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Content Section
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A303030),
                      offset: Offset(-10, 4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trip Planning Title
                      const Text(
                        'Trip Planning',
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Destination Type Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DestinationTypeButton(
                            icon: Icons.home,
                            label: 'Home',
                            isSelected: _selectedDestinationType == 'Home',
                            onTap: () => _selectDestinationType('Home'),
                          ),
                          _DestinationTypeButton(
                            icon: Icons.business,
                            label: 'Office',
                            isSelected: _selectedDestinationType == 'Office',
                            onTap: () => _selectDestinationType('Office'),
                          ),
                          _DestinationTypeButton(
                            icon: Icons.star,
                            label: 'Saved',
                            isSelected: _selectedDestinationType == 'Saved',
                            onTap: () => _selectDestinationType('Saved'),
                          ),
                          _DestinationTypeButton(
                            icon: Icons.add,
                            label: 'Others',
                            isSelected: _selectedDestinationType == 'Others',
                            onTap: () => _selectDestinationType('Others'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Divider
                      Container(
                        height: 1,
                        color: const Color(0xFFEBEBEB),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Location Input Section
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Current Location
                                  Row(
                                    children: [
                                      Container(
                                        width: 11,
                                        height: 11,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF22866E),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Current location',
                                        style: TextStyle(
                                          color: Color(0xFF707070),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Divider line
                                  Container(
                                    margin: const EdgeInsets.only(left: 28),
                                    height: 1,
                                    color: const Color(0xFF707070),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Destination
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Color(0xFFC91C1C),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                                          style: TextStyle(
                                            color: Color(0xFF1E1E1E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Navigation Arrow Button
                            Positioned(
                              right: 16,
                              top: 16,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle navigation action
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Starting navigation...'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF153462),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DestinationTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 62,
        decoration: BoxDecoration(
          color: const Color(0xFFBAD1C1),
          borderRadius: BorderRadius.circular(10),
          border: isSelected 
            ? Border.all(color: const Color(0xFF153462), width: 2)
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
