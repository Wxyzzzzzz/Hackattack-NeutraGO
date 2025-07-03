import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/carbon_footprint_card.dart';
import '../widgets/footprint_chart.dart';
import '../widgets/transportation_chart.dart';
import '../widgets/action_buttons.dart';
import 'past_trips_screen.dart';
import 'reward_centre.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import '../services/firestore_trip_service.dart';
import '../models/trip.dart';
import 'dart:math';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = 0;

  final FlutterActivityRecognition _activityRecognition =
      FlutterActivityRecognition.instance;
  Stream<Activity>? _activityStream;
  String _currentActivity = 'Unknown';
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Trip? _currentTrip;
  DateTime? _stillStartTime;
  String? _lastActivity;
  DateTime? _lastActivityStartTime;
  Timer? _stillCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initActivityRecognition();
    _stillCheckTimer =
        Timer.periodic(Duration(seconds: 30), (_) => _checkStillTimeout());
  }

  @override
  void dispose() {
    _stillCheckTimer?.cancel();
    super.dispose();
  }

  void _checkStillTimeout() async {
    final now = DateTime.now();
    if (_currentTrip != null &&
        _stillStartTime != null &&
        _currentActivity.toUpperCase() == 'STILL') {
      final diff = now.difference(_stillStartTime!).inMinutes;
      if (diff >= 1) {
        // Finalize the last stop before ending the trip
        if (_lastActivity != null && _lastActivityStartTime != null) {
          final duration =
              (now.difference(_lastActivityStartTime!).inSeconds / 60).round();
          try {
            Position endPosition = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            _currentTrip!.stops = _currentTrip!.stops ?? [];
            double co2 = 0;
            double distance = 0;
            if (_currentTrip!.stops!.isNotEmpty) {
              final prev = _currentTrip!.stops!.last;
              distance = _calculateDistance(prev.lat, prev.lng,
                  endPosition.latitude, endPosition.longitude);
            } else {
              distance = _calculateDistance(
                  _currentTrip!.startLat!,
                  _currentTrip!.startLng!,
                  endPosition.latitude,
                  endPosition.longitude);
            }
            co2 = distance * _getEmissionFactor(_lastActivity!);
            _currentTrip!.stops!.add(TripStop(
              lat: endPosition.latitude,
              lng: endPosition.longitude,
              mode: _lastActivity!,
              time: duration,
              co2: co2,
            ));
            _currentTrip!.endLat = endPosition.latitude;
            _currentTrip!.endLng = endPosition.longitude;
            // Update total trip CO2
            _currentTrip!.co2Emitted = (_currentTrip!.stops
                    ?.fold(0.0, (sum, s) => (sum ?? 0) + s.co2)) ??
                0;
          } catch (e) {
            print('Error getting end location: \\${e.toString()}');
          }
        }
        _currentTrip!.endTime = now;
        // Set co2Saved and pointRewarded to the same random value between 5 and 20
        final randomReward = 5 + Random().nextInt(16); // 5 to 20 inclusive
        _currentTrip!.co2Saved = randomReward.toDouble();
        _currentTrip!.pointRewarded = randomReward;
        await FirestoreTripService().uploadTrip(_currentTrip!);
        print('Trip ended and updated in Firebase. (timer)');
        _currentTrip = null;
        _stillStartTime = null;
        _lastActivity = null;
        _lastActivityStartTime = null;
      }
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showActivityNotification(String activity) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'activity_channel',
      'Activity Changes',
      channelDescription: 'Notification channel for activity changes',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Activity Changed',
      'Detected activity: $activity',
      platformChannelSpecifics,
    );
  }

  Future<void> _initActivityRecognition() async {
    ActivityPermission permission =
        await _activityRecognition.checkPermission();
    if (permission == ActivityPermission.DENIED) {
      permission = await _activityRecognition.requestPermission();
    }
    if (permission == ActivityPermission.GRANTED) {
      _activityStream = _activityRecognition.activityStream;
      _activityStream!.listen(
        (activity) async {
          print('Activity event received: \\${activity.type}');
          setState(() {
            _currentActivity = activity.type.toString().split('.').last;
          });
          _showActivityNotification(_currentActivity);
          // Get current location on activity change
          try {
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
              print('Location services are disabled.');
              return;
            }
            LocationPermission locationPermission =
                await Geolocator.checkPermission();
            if (locationPermission == LocationPermission.denied) {
              locationPermission = await Geolocator.requestPermission();
              if (locationPermission == LocationPermission.denied) {
                print('Location permissions are denied');
                return;
              }
            }
            if (locationPermission == LocationPermission.deniedForever) {
              print('Location permissions are permanently denied.');
              return;
            }
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print(
                'Current location: \\${position.latitude}, \\${position.longitude}');
            final user = FirebaseAuth.instance.currentUser;
            final now = DateTime.now();
            final activityType = activity.type.toString().split('.').last;
            final activityTypeUpper = activityType.toUpperCase();
            if (activityTypeUpper != 'STILL' &&
                activityTypeUpper != 'UNKNOWN') {
              // Start a new trip if not already started
              if (_currentTrip == null) {
                _currentTrip = Trip(
                  startTime: now,
                  activity: TripActivity.values.firstWhere(
                    (a) =>
                        a.toString().split('.').last.toUpperCase() ==
                        activityTypeUpper,
                    orElse: () => TripActivity.walking,
                  ),
                  startLat: position.latitude,
                  startLng: position.longitude,
                  userId: user?.uid,
                  stops: [],
                );
                _lastActivity = activityTypeUpper;
                _lastActivityStartTime = now;
                await FirestoreTripService().uploadTrip(_currentTrip!);
                print('Trip started and saved to Firebase.');
              } else {
                // If activity changed, add a stop for the previous activity
                if (_lastActivity != null &&
                    _lastActivityStartTime != null &&
                    _lastActivity != activityTypeUpper) {
                  final duration =
                      (now.difference(_lastActivityStartTime!).inSeconds / 60)
                          .round();
                  _currentTrip!.stops = _currentTrip!.stops ?? [];
                  double co2 = 0;
                  double distance = 0;
                  if (_currentTrip!.stops!.isNotEmpty) {
                    final prev = _currentTrip!.stops!.last;
                    distance = _calculateDistance(prev.lat, prev.lng,
                        position.latitude, position.longitude);
                  } else {
                    distance = _calculateDistance(
                        _currentTrip!.startLat!,
                        _currentTrip!.startLng!,
                        position.latitude,
                        position.longitude);
                  }
                  co2 = distance * _getEmissionFactor(_lastActivity!);
                  _currentTrip!.stops!.add(TripStop(
                    lat: position.latitude,
                    lng: position.longitude,
                    mode: _lastActivity!,
                    time: duration,
                    co2: co2,
                  ));
                  _lastActivity = activityTypeUpper;
                  _lastActivityStartTime = now;
                  // Update total trip CO2
                  _currentTrip!.co2Emitted = (_currentTrip!.stops
                          ?.fold(0.0, (sum, s) => (sum ?? 0) + s.co2)) ??
                      0;
                  await FirestoreTripService().uploadTrip(_currentTrip!);
                  print(
                      'Added stop for activity: \\${_lastActivity} duration: \\${duration}m, distance: \\${distance}km, co2: \\${co2}g');
                }
              }
              _stillStartTime = null;
            } else if (activityTypeUpper == 'STILL') {
              // If activity is STILL, start or update the timer
              if (_stillStartTime == null) {
                _stillStartTime = now;
              } else {
                final diff = now.difference(_stillStartTime!).inMinutes;
                if (diff >= 1 && _currentTrip != null) {
                  // Finalize the last stop before ending the trip
                  if (_lastActivity != null && _lastActivityStartTime != null) {
                    final duration =
                        (now.difference(_lastActivityStartTime!).inSeconds / 60)
                            .round();
                    try {
                      Position endPosition =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);
                      _currentTrip!.stops = _currentTrip!.stops ?? [];
                      double co2 = 0;
                      double distance = 0;
                      if (_currentTrip!.stops!.isNotEmpty) {
                        final prev = _currentTrip!.stops!.last;
                        distance = _calculateDistance(prev.lat, prev.lng,
                            endPosition.latitude, endPosition.longitude);
                      } else {
                        distance = _calculateDistance(
                            _currentTrip!.startLat!,
                            _currentTrip!.startLng!,
                            endPosition.latitude,
                            endPosition.longitude);
                      }
                      co2 = distance * _getEmissionFactor(_lastActivity!);
                      _currentTrip!.stops!.add(TripStop(
                        lat: endPosition.latitude,
                        lng: endPosition.longitude,
                        mode: _lastActivity!,
                        time: duration,
                        co2: co2,
                      ));
                      _currentTrip!.endLat = endPosition.latitude;
                      _currentTrip!.endLng = endPosition.longitude;
                      // Update total trip CO2
                      _currentTrip!.co2Emitted = (_currentTrip!.stops
                              ?.fold(0.0, (sum, s) => (sum ?? 0) + s.co2)) ??
                          0;
                    } catch (e) {
                      print('Error getting end location: \\${e.toString()}');
                    }
                  }
                  _currentTrip!.endTime = now;
                  // Set co2Saved and pointRewarded to the same random value between 5 and 20
                  final randomReward =
                      5 + Random().nextInt(16); // 5 to 20 inclusive
                  _currentTrip!.co2Saved = randomReward.toDouble();
                  _currentTrip!.pointRewarded = randomReward;
                  await FirestoreTripService().uploadTrip(_currentTrip!);
                  print('Trip ended and updated in Firebase.');
                  _currentTrip = null;
                  _stillStartTime = null;
                  _lastActivity = null;
                  _lastActivityStartTime = null;
                }
              }
            }
          } catch (e) {
            print('Error getting location or saving trip: \\${e.toString()}');
          }
        },
        onError: (error) {
          print('Activity stream error: $error');
          setState(() {
            _currentActivity = 'Error: $error';
          });
        },
        cancelOnError: false,
      );
    } else {
      print('Activity Recognition Permission: $permission');
      setState(() {
        _currentActivity = 'Permission Denied';
      });
    }
  }

  String _userFriendlyActivityMessage() {
    if (_currentActivity.startsWith('Error:') ||
        _currentActivity == 'Unknown') {
      return 'Activity recognition is not available on your device.';
    } else if (_currentActivity == 'Permission Denied' ||
        _currentActivity == 'Permission Permanently Denied') {
      return 'Activity recognition permission is denied.';
    } else {
      return 'Current Activity: $_currentActivity';
    }
  }

  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371; // Earth radius in km
    final dLat = (lat2 - lat1) * 3.141592653589793 / 180.0;
    final dLng = (lng2 - lng1) * 3.141592653589793 / 180.0;
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * 3.141592653589793 / 180.0) *
            cos(lat2 * 3.141592653589793 / 180.0) *
            (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _getEmissionFactor(String mode) {
    switch (mode.toUpperCase()) {
      case 'CAR':
        return 1200; // g/km
      case 'MOTORCYCLE':
        return 900; // g/km
      case 'LRT':
      case 'TRAIN':
        return 80; // g/km
      case 'WALKING':
      case 'RUNNING':
      default:
        return 0; // g/km
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F2E4),
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hi, ${user?.displayName ?? 'there'}!',
              style: const TextStyle(
                color: Color(0xFF153462),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PastTripsScreen()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFB5D3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.history,
                  color: Color(0xFF153462),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Recognition Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFCCD6DD)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_walk,
                    color: Color(0xFF153462),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _userFriendlyActivityMessage(),
                      style: const TextStyle(
                        color: Color(0xFF707070),
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Carbon Footprint Card
            const CarbonFootprintCard(),
            const SizedBox(height: 16),

            // Settings Dropdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFCCD6DD)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: Color(0xFF153462),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xFF153462),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '7 days',
                    style: TextStyle(
                      color: Color(0xFF707070),
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF153462),
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Line Chart
            const FootprintChart(userId: 'jAENInMkzS0KvYyVSyJA'),
            const SizedBox(height: 16),

            // Transportation Chart
            const TransportationChart(userId: 'jAENInMkzS0KvYyVSyJA'),
            const SizedBox(height: 16),

            // Action Buttons
            const ActionButtons(),
            const SizedBox(height: 30), // Space for bottom navigation
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
        currentIndex: 0, // Home is selected
        onTap: (index) {
          if (index == 0) {
            // Already on HomeScreen
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PastTripsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RewardsCentrePage()),
            );
          } else if (index == 3) {
            // Placeholder for Profile
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
}
