import 'package:flutter/material.dart';
import 'package:hackattack/screens/home_screen.dart';
import '../widgets/trip_card.dart';
import '../widgets/date_selector.dart';

class PastTripsScreen extends StatelessWidget {
  const PastTripsScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned(
                    left: 19,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF153462),
                        size: 27,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Container(
                  //     width: 40,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFB5D3C7),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Icon(
                  //       Icons.arrow_back,
                  //       color: Color(0xFF153462),
                  //       size: 20,
                  //     ),
                  //   ),
                  // const Spacer(),
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
                  Positioned(
                    right: 19,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.question_answer,
                        color: const Color(0xFFF3F2E3),
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Date Selector
            const DateSelector(),
            
            // Trip List
            Expanded(
              child: Container(
                color: const Color(0xFFBAD1C1),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: ListView(
                  children: const [
                    TripCard(
                      date: '15 Apr',
                      time: '06:28 pm',
                      startLocation: 'Queensbay Mall',
                      endLocation: 'Georgetown',
                      mapImageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/004ac4e57aa251837d22640ba578e3727129b285?width=696',
                    ),
                    SizedBox(height: 22),
                    TripCard(
                      date: '14 Apr',
                      time: '07:21 am',
                      startLocation: 'USM',
                      endLocation: 'USM Library',
                      mapImageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/004ac4e57aa251837d22640ba578e3727129b285?width=696',
                    ),
                    SizedBox(height: 22),
                    TripCard(
                      date: '14 Apr',
                      time: '10:33 am',
                      startLocation: 'Gurney Paragon',
                      endLocation: 'Georgetown',
                      mapImageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/004ac4e57aa251837d22640ba578e3727129b285?width=696',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
