import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/carbon_footprint_card.dart';
import '../widgets/footprint_chart.dart';
import '../widgets/transportation_chart.dart';
import '../widgets/action_buttons.dart';
import 'past_trips_screen.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initActivityRecognition();
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
        (activity) {
          print('Activity event received: ${activity.type}');
          setState(() {
            _currentActivity = activity.type.toString().split('.').last;
          });
          _showActivityNotification(_currentActivity);
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
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: const Color(0xFF7A9B5A),
      //   unselectedItemColor: const Color(0xFF707070),
      //   showSelectedLabels: true,
      //   showUnselectedLabels: false,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.eco),
      //       label: 'Trip',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.card_giftcard),
      //       label: 'Rewards',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
