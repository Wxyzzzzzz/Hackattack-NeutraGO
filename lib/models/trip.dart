import 'package:cloud_firestore/cloud_firestore.dart';

enum TripActivity { walking, running, car, motorcycle, bus, lrt }

class TripStop {
  final double lat;
  final double lng;
  final String mode;
  final int time; // seconds
  final double co2;
  final double? timeWeight;

  TripStop({
    required this.lat,
    required this.lng,
    required this.mode,
    required this.time,
    required this.co2,
    this.timeWeight,
  });

  Map<String, dynamic> toMap() => {
        'geopoint': GeoPoint(lat, lng),
        'mode': mode,
        'time': time,
        'co2': co2,
        if (timeWeight != null) 'time_weight': timeWeight,
      };
}

class Trip {
  final String? id;
  final DateTime startTime;
  DateTime? endTime;
  final TripActivity activity;
  double? distanceKm;
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;
  double? co2Emitted;
  double? co2Saved;
  double? co2Weight;
  int? pointRewarded;
  String? userId;
  List<TripStop>? stops;
  String? originName;
  String? destinationName;

  Trip({
    this.id,
    required this.startTime,
    this.endTime,
    required this.activity,
    this.distanceKm,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.co2Emitted,
    this.co2Saved,
    this.co2Weight,
    this.pointRewarded,
    this.userId,
    this.stops,
    this.originName,
    this.destinationName,
  });

  Map<String, dynamic> toMap() => {
        'co2_emitted': co2Emitted ?? 0,
        'co2_saved': co2Saved ?? 0,
        'co2_weight': co2Weight ?? 0,
        'origin': (startLat != null && startLng != null)
            ? GeoPoint(startLat!, startLng!)
            : null,
        'destination': (endLat != null && endLng != null)
            ? GeoPoint(endLat!, endLng!)
            : null,
        'starttimestamp': Timestamp.fromDate(startTime),
        'endtimestamp': endTime != null ? Timestamp.fromDate(endTime!) : null,
        'point_rewarded': pointRewarded ?? 0,
        'user_id': userId,
        'stops': stops?.map((s) => s.toMap()).toList() ?? [],
      }..removeWhere((key, value) => value == null);
}
