import 'package:flutter/material.dart';
import '../widgets/transportation_mode_card.dart';
import '../widgets/congestion_table_card.dart';

class CarbonCalculator extends StatelessWidget {
  const CarbonCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F2E3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF044642),
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'How was your trip calculated?',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
          child: Column(
            children: [
              // Walking Card
              TransportationModeCard(
                icon: Icons.directions_walk,
                title: 'Walking',
                emissions: '0 g/km',
                backgroundColor: const Color(0xFFBAD1C1),
              ),
              const SizedBox(height: 23),
              
              // Car Card with Congestion Table
              CongestionTableCard(
                icon: Icons.directions_car,
                title: 'Car',
                emissions: '1.2 kg/km',
                backgroundColor: const Color(0xFFBAD1C1),
              ),
              const SizedBox(height: 23),
              
              // Motorcycle Card with Congestion Table
              CongestionTableCard(
                icon: Icons.motorcycle,
                title: 'Motorcycle',
                emissions: '900 g/km',
                backgroundColor: const Color(0xFFBAD1C1),
              ),
              const SizedBox(height: 23),
              
              // Public Transit Card
              PublicTransitCard(
                backgroundColor: const Color(0xFFBAD1C1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PublicTransitCard extends StatelessWidget {
  final Color backgroundColor;

  const PublicTransitCard({
    super.key,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 41, top: 14, right: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.black,
                  size: 19,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Public Transit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          
          // Bus Section with Congestion Table
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 19, bottom: 6),
                  child: Text(
                    'Bus',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Container(
                  width: 289,
                  height: 102,
                  decoration: BoxDecoration(
                    color: const Color(0xFF367970),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      // Table Headers
                      const Positioned(
                        left: 15,
                        top: 6,
                        child: Text(
                          'Congestion Level',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 125,
                        top: 6,
                        child: Text(
                          'Speed (km/h)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 217,
                        top: 6,
                        child: Text(
                          'Adjustment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      
                      // Table Data
                      const Positioned(
                        left: 39,
                        top: 29,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Low',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Medium',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'High',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        left: 129,
                        top: 29,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '≥ 60',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '≥ 30 and <60',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '< 30',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        left: 232,
                        top: 29,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'None',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '+ 15%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '+ 40%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Table separators
                      Positioned(
                        left: 114,
                        top: 10,
                        child: Container(
                          width: 1,
                          height: 85,
                          color: const Color(0xFF121212),
                        ),
                      ),
                      Positioned(
                        left: 213,
                        top: 10,
                        child: Container(
                          width: 1,
                          height: 85,
                          color: const Color(0xFF121212),
                        ),
                      ),
                      Positioned(
                        left: 11,
                        top: 31,
                        child: Container(
                          width: 269,
                          height: 1,
                          color: const Color(0xFF121212),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Emissions values section
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bus',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Text(
                      '90 g/km',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'LRT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Text(
                      '70 g/km',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MRT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Text(
                      '80 g/km',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Komuter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Text(
                      '50 g/km',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
