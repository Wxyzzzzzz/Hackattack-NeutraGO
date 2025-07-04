import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/location_search_field.dart';

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

  final LatLng _homeLocation = const LatLng(5.3364, 100.2858);
  final LatLng _officeLocation = const LatLng(5.3206, 100.2852);
  final LatLng _schoolLocation = const LatLng(5.3560, 100.2954);
  final LatLng _favLocation = const LatLng(5.4164, 100.3327);

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

    if (type == 'Home') {
      _goToLocation(_homeLocation, label: 'Home');
    } else if (type == 'Office') {
      _goToLocation(_officeLocation, label: 'Office');
    } else if (type == 'School') {
      _goToLocation(_schoolLocation, label: 'School');
    } else if (type == 'Favourite') {
      _goToLocation(_favLocation, label: 'Favourite');
    }
  }

  void _goToLocation(LatLng location, {String label = 'Location'}) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16));

    setState(() {
      // _markers.removeWhere((m) => m.markerId == MarkerId('selected'));
      _searchController.text = label;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected'),
          position: location,
          infoWindow: InfoWindow(title: label),
        ),
      );
      _selectedDestination = location;
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
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
        child: Column(
          children: [
            // ⬆ Top Section: Search Bar + Map + Floating Suggestions
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Stack(
                children: [
                  // 🗺 Map Layer
                  Positioned.fill(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target:
                            _currentMapCenter ?? const LatLng(5.36, 100.302),
                        // target: LatLng(5.36, 100.302),
                        zoom: 13.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      markers: _markers,
                    ),
                  ),

                  // 🔍 Search Bar (above map)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
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
                              // onPressed: () => _onSearchChanged(_searchController.text),
                              onPressed: () async {
                                final inputText = _searchController.text.trim();

                                if (inputText.isEmpty ||
                                    _selectedDestination == null) {
                                  _onSearchChanged(
                                      inputText); // Still allow autocomplete to function
                                  return;
                                }

                                // 🧭 Same as "Go" button logic
                                final position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                final LatLng currentLatLng = LatLng(
                                    position.latitude, position.longitude);
                                // const LatLng currentLatLng = LatLng(5.36, 100.302);
                                final DateTime timestamp = DateTime.now();
                                const String userId =
                                    'user_001'; // Replace with actual user ID if needed

                                if (!context.mounted) return;

                                mapController.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      _selectedDestination!, 16),
                                );

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
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 📍 Suggestions box (floating below search bar)
                  if (_showSuggestions && _placePredictions.isNotEmpty)
                    Positioned(
                      top: 80, // right below the search bar
                      left: 16,
                      right: 16,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
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
                    ),
                ],
              ),
            ),

            // ⬇ Bottom Section: Trip Planner
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip Planning',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1, color: const Color(0xFFEBEBEB)),
                      const SizedBox(height: 24),
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
                            icon: Icons.school,
                            label: 'School',
                            isSelected: _selectedDestinationType == 'School',
                            onTap: () => _selectDestinationType('School'),
                          ),
                          _DestinationTypeButton(
                            icon: Icons.favorite,
                            label: 'Favourite',
                            isSelected: _selectedDestinationType == 'Favourite',
                            onTap: () => _selectDestinationType('Favourite'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // More fields or a "Go" button can be added here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       // 🔍 Search Bar always fixed at the top
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      //         child: Material(
      //           elevation: 4,
      //           borderRadius: BorderRadius.circular(15),
      //           child: Column(
      //             children: [
      //               Container(
      //                 height: 56,
      //                 decoration: BoxDecoration(
      //                   color: const Color(0xFFD9D9D9),
      //                   borderRadius: BorderRadius.circular(15),
      //                 ),
      //                 child: Row(
      //                   children: [
      //                     const SizedBox(width: 16),
      //                     const Icon(Icons.place, color: Color(0xFFC81C1C)),
      //                     const SizedBox(width: 12),
      //                     Expanded(
      //                       child: TextField(
      //                         controller: _searchController,
      //                         focusNode: _searchFocusNode,
      //                         decoration: const InputDecoration(
      //                           hintText: 'Enter a place you want to go',
      //                           border: InputBorder.none,
      //                         ),
      //                         onChanged: _onSearchChanged,
      //                       ),
      //                     ),
      //                     IconButton(
      //                       icon: const Icon(Icons.search, color: Color(0xFF153462)),
      //                       onPressed: () => _onSearchChanged(_searchController.text),
      //                     ),
      //                     const SizedBox(width: 8),
      //                   ],
      //                 ),
      //               ),
      //               if (_showSuggestions && _placePredictions.isNotEmpty)
      //                 Container(
      //                   width: double.infinity,
      //                   constraints: const BoxConstraints(maxHeight: 250),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(10),
      //                     boxShadow: const [
      //                       BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
      //                     ],
      //                   ),
      //                   child: ListView.builder(
      //                     shrinkWrap: true,
      //                     itemCount: _placePredictions.length,
      //                     itemBuilder: (context, index) {
      //                       final prediction = _placePredictions[index];
      //                       return ListTile(
      //                         title: Text(prediction['description']),
      //                         onTap: () => _onSuggestionTap(prediction),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //             ],
      //           ),
      //         ),
      //       ),

      //       // 🗺 Google Map view (adjust height as needed)
      //       Container(
      //         width: double.infinity,
      //         height: MediaQuery.of(context).size.height * 0.4,
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(0),
      //           child: GoogleMap(
      //             onMapCreated: _onMapCreated,
      //             initialCameraPosition: CameraPosition(
      //               target: _currentMapCenter ?? const LatLng(5.36, 100.302),
      //               zoom: 13.0,
      //             ),
      //             myLocationEnabled: true,
      //             myLocationButtonEnabled: true,
      //             zoomControlsEnabled: true,
      //             markers: _markers,
      //           ),
      //         ),
      //       ),

      //       // 📋 Trip Planning Details Section
      //       Expanded(
      //         child: Container(
      //           decoration: const BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(20),
      //               topRight: Radius.circular(20),
      //             ),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black12,
      //                 offset: Offset(0, -2),
      //                 blurRadius: 12,
      //               ),
      //             ],
      //           ),
      //           child: SingleChildScrollView(
      //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text(
      //                   'Trip Planning',
      //                   style: TextStyle(
      //                     fontSize: 24,
      //                     fontWeight: FontWeight.bold,
      //                     color: Color(0xFF1E1E1E),
      //                   ),
      //                 ),
      //                 const SizedBox(height: 12),
      //                 Container(height: 1, color: const Color(0xFFEBEBEB)),
      //                 const SizedBox(height: 24),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     _DestinationTypeButton(
      //                       icon: Icons.home,
      //                       label: 'Home',
      //                       isSelected: _selectedDestinationType == 'Home',
      //                       onTap: () => _selectDestinationType('Home'),
      //                     ),
      //                     _DestinationTypeButton(
      //                       icon: Icons.business,
      //                       label: 'Office',
      //                       isSelected: _selectedDestinationType == 'Office',
      //                       onTap: () => _selectDestinationType('Office'),
      //                     ),
      //                     _DestinationTypeButton(
      //                       icon: Icons.school,
      //                       label: 'School',
      //                       isSelected: _selectedDestinationType == 'Saved',
      //                       onTap: () => _selectDestinationType('Saved'),
      //                     ),
      //                     _DestinationTypeButton(
      //                       icon: Icons.favorite,
      //                       label: 'Favourite',
      //                       isSelected: _selectedDestinationType == 'Others',
      //                       onTap: () => _selectDestinationType('Others'),
      //                     ),
      //                   ],
      //                 ),
      //                 const SizedBox(height: 24),
      //                 // Add more input fields or buttons here if needed
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
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
