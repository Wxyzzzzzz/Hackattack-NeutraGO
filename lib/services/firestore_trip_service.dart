import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip.dart';

class FirestoreTripService {
  static final _instance = FirestoreTripService._internal();
  factory FirestoreTripService() => _instance;
  FirestoreTripService._internal();

  final CollectionReference tripCollection =
      FirebaseFirestore.instance.collection('trips');

  Future<void> uploadTrip(Trip trip) async {
    final docRef =
        trip.id != null ? tripCollection.doc(trip.id) : tripCollection.doc();
    await docRef.set(trip.toMap());
  }

  Future<Trip?> fetchTripById(String tripId) async {
    final doc = await tripCollection.doc(tripId).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    // Parse stops if present
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
      startLat:
          data['origin'] != null ? (data['origin'] as GeoPoint).latitude : null,
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
    );
  }
}
