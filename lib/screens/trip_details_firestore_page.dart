import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trip.dart';
import '../services/firestore_trip_service.dart';

class TripDetailsFirestorePage extends StatefulWidget {
  final String tripId;
  const TripDetailsFirestorePage({super.key, required this.tripId});

  @override
  State<TripDetailsFirestorePage> createState() =>
      _TripDetailsFirestorePageState();
}

class _TripDetailsFirestorePageState extends State<TripDetailsFirestorePage> {
  Trip? trip;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    print('TripDetailsFirestorePage: tripId = \\${widget.tripId}');
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    print('Fetching trip with ID: \\${widget.tripId}');
    final fetched = await FirestoreTripService().fetchTripById(widget.tripId);
    print('Trip fetch result: \\${fetched}');
    setState(() {
      trip = fetched;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('TripDetailsFirestorePage build: loading=\\$loading, trip=\\$trip');
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (trip == null) {
      return const Scaffold(body: Center(child: Text('Trip not found')));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 62,
              color: const Color(0xFFF3F2E4),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF153462)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF153462),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Map or placeholder
            SizedBox(
              width: double.infinity,
              height: 220,
              child: (trip!.startLat != null &&
                      trip!.startLng != null &&
                      trip!.endLat != null &&
                      trip!.endLng != null)
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(trip!.startLat!, trip!.startLng!),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('start'),
                          position: LatLng(trip!.startLat!, trip!.startLng!),
                          infoWindow: const InfoWindow(title: 'Start'),
                        ),
                        Marker(
                          markerId: const MarkerId('end'),
                          position: LatLng(trip!.endLat!, trip!.endLng!),
                          infoWindow: const InfoWindow(title: 'End'),
                        ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          color: Colors.blue,
                          width: 5,
                          points: [
                            LatLng(trip!.startLat!, trip!.startLng!),
                            LatLng(trip!.endLat!, trip!.endLng!),
                          ],
                        ),
                      },
                    )
                  : Container(
                      color: const Color(0xFFE0E0E0),
                      child: const Center(
                        child: Icon(Icons.map, size: 80, color: Colors.grey),
                      ),
                    ),
            ),
            // Trip details and segments
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFBADCBC),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...?_buildSegments(trip!),
                      const Spacer(),
                      _summaryCard(trip!),
                      const SizedBox(height: 16),
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

  List<Widget> _buildSegments(Trip trip) {
    if (trip.stops == null || trip.stops!.isEmpty) {
      // Fallback: show main trip
      final duration = trip.endTime != null
          ? trip.endTime!.difference(trip.startTime)
          : const Duration(minutes: 10);
      return [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(_activityIcon(trip.activity),
                  color: const Color(0xFF153462)),
            ),
            const SizedBox(width: 16),
            Text(
              '[200C${_activityLabel(trip.activity)} for ${_formatDuration(duration)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF153462),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('CO₂ emitted: ${trip.co2Emitted?.toStringAsFixed(0) ?? '-'}g',
            style: const TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 24),
      ];
    }
    // Show each stop/segment
    List<Widget> widgets = [];
    for (final stop in trip.stops!) {
      widgets.add(Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(_modeIcon(stop.mode), color: const Color(0xFF153462)),
          ),
          const SizedBox(width: 16),
          Text(
            '${_modeLabel(stop.mode)} for ${_formatDuration(Duration(seconds: stop.time))}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF153462),
            ),
          ),
        ],
      ));
      widgets.add(Text('CO₂ emitted: ${stop.co2.toStringAsFixed(0)}g',
          style: const TextStyle(fontSize: 16, color: Colors.black)));
      widgets.add(const SizedBox(height: 16));
    }
    return widgets;
  }

  Widget _summaryCard(Trip trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Total CO₂ emitted: ${trip.co2Emitted?.toStringAsFixed(0) ?? '-'} g',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('CO₂ saved: ${trip.co2Saved?.toStringAsFixed(0) ?? '-'} g',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text('Points rewarded: ${trip.pointRewarded ?? '-'} pt',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  IconData _activityIcon(TripActivity activity) {
    switch (activity) {
      case TripActivity.walking:
        return Icons.directions_walk;
      case TripActivity.running:
        return Icons.directions_run;
      case TripActivity.car:
        return Icons.directions_car;
      case TripActivity.motorcycle:
        return Icons.motorcycle;
      case TripActivity.bus:
        return Icons.directions_bus;
      case TripActivity.lrt:
        return Icons.tram;
    }
  }

  IconData _modeIcon(String mode) {
    switch (mode) {
      case 'walk':
        return Icons.directions_walk;
      case 'run':
        return Icons.directions_run;
      case 'car':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'bus':
        return Icons.directions_bus;
      case 'lrt':
        return Icons.tram;
      default:
        return Icons.directions;
    }
  }

  String _activityLabel(TripActivity activity) {
    switch (activity) {
      case TripActivity.walking:
        return 'Walking';
      case TripActivity.running:
        return 'Running';
      case TripActivity.car:
        return 'Driving';
      case TripActivity.motorcycle:
        return 'Motorcycle';
      case TripActivity.bus:
        return 'Bus';
      case TripActivity.lrt:
        return 'LRT';
    }
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'walk':
        return 'Walking';
      case 'run':
        return 'Running';
      case 'car':
        return 'Driving';
      case 'motorcycle':
        return 'Motorcycle';
      case 'bus':
        return 'Bus';
      case 'lrt':
        return 'LRT';
      default:
        return mode;
    }
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes < 1) return '${d.inSeconds}s';
    if (d.inHours < 1) return '${d.inMinutes} mins';
    return '${d.inHours}h ${d.inMinutes % 60}m';
  }
}
