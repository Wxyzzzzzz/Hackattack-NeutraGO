import 'package:flutter/material.dart';
import '../widgets/trip_card.dart';
import '../widgets/date_selector.dart';
import '../services/firestore_trip_service.dart';
import '../models/trip.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'trip_details_firestore_page.dart';
import 'package:geocoding/geocoding.dart';
import 'home_screen.dart';
import 'reward_centre.dart';

class PastTripsScreen extends StatefulWidget {
  const PastTripsScreen({super.key});

  @override
  State<PastTripsScreen> createState() => _PastTripsScreenState();
}

class _PastTripsScreenState extends State<PastTripsScreen> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 91,
              color: const Color(0xFFF3F2E3),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF153462)),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const Spacer(),
                  const Text(
                    'Past Trips',
                    style: TextStyle(
                      color: Color(0xFF153462),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Date Selector
            DateSelector(
              selectedMonth: _selectedMonth,
              onMonthChanged: (newMonth) {
                setState(() {
                  _selectedMonth = newMonth;
                });
              },
            ),

            // Trip List
            Expanded(
              child: Container(
                color: const Color(0xFFBAD1C1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: FutureBuilder<List<Trip>>(
                  future: _fetchTrips(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No trips found.'));
                    }
                    final trips = snapshot.data!;
                    final filteredTrips = trips.where((trip) {
                      return trip.startTime.year == _selectedMonth.year &&
                          trip.startTime.month == _selectedMonth.month;
                    }).toList();
                    if (filteredTrips.isEmpty) {
                      return const Center(
                          child: Text('No trips found for this month.'));
                    }
                    return ListView.separated(
                      itemCount: filteredTrips.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 22),
                      itemBuilder: (context, index) {
                        final trip = filteredTrips[index];
                        // Print the generated map image URL for debugging
                        print(_generateMapImageUrl(trip));
                        return FutureBuilder<List<String>>(
                          future: _getLocationNames(trip),
                          builder: (context, snapshot) {
                            String startName = 'Unknown';
                            String endName = 'Unknown';
                            if (snapshot.hasData) {
                              startName = snapshot.data![0];
                              endName = snapshot.data![1];
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TripDetailsFirestorePage(
                                            tripId: trip.id!),
                                  ),
                                );
                              },
                              child: TripCard(
                                date: _formatDate(trip.startTime),
                                time: _formatTime(trip.startTime),
                                startLocation: startName,
                                endLocation: endName,
                                mapImageUrl: _generateMapImageUrl(trip),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF22866E),
        unselectedItemColor: const Color(0xFF9A9A9A),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 1, // Planner is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RewardsCentrePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<List<Trip>> _fetchTrips() async {
    // Hardcode the user ID as jAENInMkzS0KvYyVSyJA
    const hardcodedUserId = 'jAENInMkzS0KvYyVSyJA';

    print('DEBUG: Using hardcoded user ID: $hardcodedUserId');

    final querySnapshot = await FirestoreTripService()
        .tripCollection
        .where('user_id', isEqualTo: hardcodedUserId)
        .get();

    print(
        'DEBUG: Found ${querySnapshot.docs.length} trips for user $hardcodedUserId');

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      List<TripStop>? stops;
      if (data['stops'] != null && data['stops'] is List) {
        stops = (data['stops'] as List)
            .map((s) => TripStop(
                  lat: (s['geopoint'] as GeoPoint).latitude,
                  lng: (s['geopoint'] as GeoPoint).longitude,
                  mode: s['mode'] ?? '',
                  time: (s['time'] ?? 0) is int
                      ? s['time']
                      : (s['time'] as num).toInt(),
                  co2: (s['co2'] ?? 0).toDouble(),
                  timeWeight: s['time_weight'] != null
                      ? (s['time_weight'] as num).toDouble()
                      : null,
                ))
            .toList();
      }
      return Trip(
        id: doc.id,
        startTime: (data['starttimestamp'] as Timestamp).toDate(),
        endTime: data['endtimestamp'] != null
            ? (data['endtimestamp'] as Timestamp).toDate()
            : null,
        activity: TripActivity.values.firstWhere(
          (a) => a.toString().split('.').last == (data['mode'] ?? ''),
          orElse: () => TripActivity.walking,
        ),
        distanceKm: data['distanceKm'] != null
            ? (data['distanceKm'] as num).toDouble()
            : null,
        startLat: data['origin'] != null
            ? (data['origin'] as GeoPoint).latitude
            : null,
        startLng: data['origin'] != null
            ? (data['origin'] as GeoPoint).longitude
            : null,
        endLat: data['destination'] != null
            ? (data['destination'] as GeoPoint).latitude
            : null,
        endLng: data['destination'] != null
            ? (data['destination'] as GeoPoint).longitude
            : null,
        co2Emitted: data['co2_emitted'] != null
            ? (data['co2_emitted'] as num).toDouble()
            : null,
        co2Saved: data['co2_saved'] != null
            ? (data['co2_saved'] as num).toDouble()
            : null,
        co2Weight: data['co2_weight'] != null
            ? (data['co2_weight'] as num).toDouble()
            : null,
        pointRewarded: data['point_rewarded'] != null
            ? (data['point_rewarded'] as num).toInt()
            : null,
        userId: data['user_id'],
        stops: stops,
        originName: data['origin_name'],
        destinationName: data['destination_name'],
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Future<List<String>> _getLocationNames(Trip trip) async {
    String start = 'Unknown';
    String end = 'Unknown';
    if (trip.startLat != null && trip.startLng != null) {
      try {
        final placemarks =
            await placemarkFromCoordinates(trip.startLat!, trip.startLng!);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          start = [p.name, p.locality, p.administrativeArea, p.country]
              .where((e) => e != null && e.isNotEmpty)
              .join(', ');
        }
      } catch (_) {}
    }
    if (trip.endLat != null && trip.endLng != null) {
      try {
        final placemarks =
            await placemarkFromCoordinates(trip.endLat!, trip.endLng!);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          end = [p.name, p.locality, p.administrativeArea, p.country]
              .where((e) => e != null && e.isNotEmpty)
              .join(', ');
        }
      } catch (_) {}
    }
    return [start, end];
  }

  String _generateMapImageUrl(Trip trip) {
    // Insert your Google Maps Static API key here
    const apiKey = 'AIzaSyCp0J_hsaPdeyjtkJrBw8bmXHYET4o75rQ';
    if (trip.startLat != null &&
        trip.startLng != null &&
        trip.endLat != null &&
        trip.endLng != null) {
      final start = '${trip.startLat},${trip.startLng}';
      final end = '${trip.endLat},${trip.endLng}';
      return 'https://maps.googleapis.com/maps/api/staticmap?size=348x142&markers=color:green|$start&markers=color:red|$end&path=color:0x0000ff|weight:5|$start|$end&key=$apiKey';
    } else {
      // Placeholder image if coordinates are missing
      return 'https://via.placeholder.com/348x142?text=No+Map+Available';
    }
  }
}
