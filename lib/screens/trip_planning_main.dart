import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'running_model.dart';
import 'rout_api_call.dart';

class TripPlanningMainPage extends StatefulWidget {
  const TripPlanningMainPage({Key? key}) : super(key: key);

  @override
  State<TripPlanningMainPage> createState() => _TripPlanningMainPageState();
}

class _TripPlanningMainPageState extends State<TripPlanningMainPage> {
  late GoogleMapController mapController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Set<Marker> _markers = {};
  final String _googleApiKey = 'AIzaSyCp0J_hsaPdeyjtkJrBw8bmXHYET4o75rQ';
  List<dynamic> _placePredictions = [];
  bool _showSuggestions = false;
  // Example initial position (Penang, Malaysia)
  // LatLng _currentMapCenter = const LatLng(5.3600, 100.3020);
  LatLng? _currentMapCenter;
  String _selectedDestinationType = '';
  LatLng? _selectedDestination;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectDestinationType(String type) {
    setState(() {
      _selectedDestinationType = type;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentMapCenter = currentLatLng;

      // ✅ Add a marker for current location
      _markers.removeWhere((m) => m.markerId == MarkerId('current_location'));
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });

    mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 15));
  }

  Future<void> _onSearchChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _placePredictions = [];
        _showSuggestions = false;
      });
      return;
    }
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$_googleApiKey&components=country:my';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _placePredictions = data['predictions'];
        _showSuggestions = true;
      });
    } else {
      setState(() {
        _placePredictions = [];
        _showSuggestions = false;
      });
    }
  }

  Future<void> _onSuggestionTap(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey';
    final detailsResponse = await http.get(Uri.parse(detailsUrl));
    if (detailsResponse.statusCode == 200) {
      final details = json.decode(detailsResponse.body);
      final location = details['result']['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];
      final name = details['result']['name'];
      final LatLng position = LatLng(lat, lng);
      mapController.animateCamera(CameraUpdate.newLatLng(position));
      setState(() {
        _selectedDestination = position;
        _searchController.text = name;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('searched_location'),
            position: position,
            infoWindow: InfoWindow(title: name),
          ),
        );
        _showSuggestions = false;
        _placePredictions = [];
      });
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.05,
                //   alignment: Alignment.center,
                //   color: const Color(0xFFF3F2E3),
                //   child: const Text(
                //     'Trip Planning',
                //     style: TextStyle(
                //       color: Color(0xFF153462),
                //       fontSize: 20,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                            
                // Blue line under header
                Container(
                  height: 3,
                  color: const Color(0xFF153462),
                ),

                // Map area
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3, // Adjust as needed for your layout
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentMapCenter ?? const LatLng(5.36, 100.302),
                        zoom: 13.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      markers: _markers,
                    ),
                  ),
                ),
                // Trip Planning UI below the map
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        // Main white rounded rectangle with shadow and trip planning UI
                        Positioned(
                          left: 1,
                          right: 1,
                          top: 0,
                          child: Container(
                            width: 402,
                            height: 328,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(-10, 4),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  const Text(
                                    'Trip Planning',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Divider
                                  Container(
                                    width: 370,
                                    height: 1,
                                    color: const Color(0xFFEBEBEB),
                                  ),
                                  const SizedBox(height: 24),
                                  // Three horizontally arranged cards
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     _TripCard(
                                  //       label: 'Home',
                                  //       color: const Color(0xFFBADCBC),
                                  //     ),
                                  //     _TripCard(
                                  //       label: 'Office',
                                  //       color: const Color(0xFFBADCBC),
                                  //     ),
                                  //     _TripCard(
                                  //       label: 'Others',
                                  //       color: const Color(0xFFBADCBC),
                                  //     ),
                                  //   ],
                                  // ),
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
                                  const SizedBox(height: 24),
                                  // Search bar for destination (only show here if not focused)
                                  // if (!_searchFocusNode.hasFocus)
                                  //   Container(
                                  //     width: double.infinity,
                                  //     height: 56,
                                  //     decoration: BoxDecoration(
                                  //       color: const Color(0xFFD9D9D9),
                                  //       borderRadius: BorderRadius.circular(15),
                                  //     ),
                                  //     child: Row(
                                  //       children: [
                                  //         const SizedBox(width: 16),
                                  //         const Icon(Icons.place,
                                  //             color: Color(0xFFC81C1C)),
                                  //         const SizedBox(width: 12),
                                  //         Expanded(
                                  //           child: TextField(
                                  //             controller: _searchController,
                                  //             focusNode: _searchFocusNode,
                                  //             decoration: const InputDecoration(
                                  //               hintText:
                                  //                   'Enter a place you want to go',
                                  //               border: InputBorder.none,
                                  //             ),
                                  //             onChanged: _onSearchChanged,
                                  //           ),
                                  //         ),
                                  //         IconButton(
                                  //           icon: const Icon(Icons.search,
                                  //               color: Color(0xFF153462)),
                                  //           onPressed: () => _onSearchChanged(
                                  //               _searchController.text),
                                  //         ),
                                  //         const SizedBox(width: 8),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // Search bar for destination (only show here if not focused)
                                if (!_searchFocusNode.hasFocus)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🔍 Search Bar
                                      Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 16),
                                            const Icon(Icons.place, color: Color(0xFFC81C1C)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: TextField(
                                                controller: _searchController,
                                                focusNode: _searchFocusNode,
                                                decoration: const InputDecoration(
                                                  hintText: 'Enter a place you want to go',
                                                  border: InputBorder.none,
                                                ),
                                                onChanged: _onSearchChanged,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.search, color: Color(0xFF153462)),
                                              onPressed: () =>
                                                  _onSearchChanged(_searchController.text),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                      ),

                                      // 🧭 "Go" Button — only show if a destination is selected
                                      if (_selectedDestination != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: Center(
                                            child: SizedBox(
                                              width: 90,
                                              height: 48,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color.fromARGB(255, 20, 97, 61),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  // Get current position
                                                  final position = await Geolocator.getCurrentPosition(
                                                      desiredAccuracy: LocationAccuracy.high);

                                                  // const LatLng currentLatLng = const LatLng(5.3573, 100.3034);
                                                  final LatLng currentLatLng = LatLng(position.latitude, position.longitude);
                                                  final DateTime timestamp = DateTime.now();
                                                  final String userId = 'user_001'; // Replace with actual user ID if needed

                                                  if (!mounted) return; 

                                                  // Animate camera to destination
                                                  mapController.animateCamera(
                                                    CameraUpdate.newLatLngZoom(_selectedDestination!, 16),
                                                  );

                                                  // Navigate to summary page
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => RunningModel(
                                                        userId: userId,
                                                        timestamp: timestamp,
                                                        currentLocation: currentLatLng,
                                                        destination: _selectedDestination!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.directions, color: Colors.white, size: 18),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Go',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Overlay the input and suggestions at the top when focused
            if (_searchFocusNode.hasFocus)
              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.place, color: Color(0xFFC81C1C)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                decoration: const InputDecoration(
                                  hintText: 'Enter a place you want to go',
                                  border: InputBorder.none,
                                ),
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search,
                                  color: Color(0xFF153462)),
                              onPressed: () =>
                                  _onSearchChanged(_searchController.text),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      if (_showSuggestions && _placePredictions.isNotEmpty)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxHeight: 250),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _placePredictions.length,
                            itemBuilder: (context, index) {
                              final prediction = _placePredictions[index];
                              return ListTile(
                                title: Text(prediction['description']),
                                onTap: () => _onSuggestionTap(prediction),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final String label;
  final Color color;
  const _TripCard({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 62,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
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
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
