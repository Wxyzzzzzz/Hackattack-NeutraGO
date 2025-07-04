import 'package:flutter/material.dart';

class CarbonBreakdownScreen extends StatelessWidget {
  const CarbonBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E3),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            _buildHeader(context, screenWidth),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.095,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Walking Card
                    _buildWalkingCard(screenWidth),
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Car Card
                    _buildCarCard(screenWidth),
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Motorcycle Card
                    _buildMotorcycleCard(screenWidth),
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Public Transit Card
                    _buildPublicTransitCard(screenWidth),
                    
                    // Bottom padding for scroll
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF044642),
                size: 28,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'How was your trip calculated?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth < 360 ? 18 : 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                letterSpacing: -0.408,
              ),
            ),
          ),
          const SizedBox(width: 44), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildWalkingCard(double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFBAD1C1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.directions_walk,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Walking',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                letterSpacing: -0.408,
              ),
            ),
            const Spacer(),
            Text(
              '0 g/km',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFBAD1C1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Car',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    letterSpacing: -0.408,
                  ),
                ),
                const Spacer(),
                Text(
                  '1.2 kg/km',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCongestionTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildMotorcycleCard(double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFBAD1C1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.motorcycle,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Motorcycle',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    letterSpacing: -0.408,
                  ),
                ),
                const Spacer(),
                Text(
                  '900 g/km',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCongestionTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicTransitCard(double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFBAD1C1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Public Transit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    letterSpacing: -0.408,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Bus section with table
            _buildPublicTransitSubSection('Bus', '90 g/km', hasTable: true),
            const SizedBox(height: 12),
            
            // Other transit modes
            _buildPublicTransitSubSection('LRT', '70 g/km'),
            const SizedBox(height: 8),
            _buildPublicTransitSubSection('MRT', '80 g/km'),
            const SizedBox(height: 8),
            _buildPublicTransitSubSection('Komuter', '50 g/km'),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicTransitSubSection(String mode, String emission, {bool hasTable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              mode,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                letterSpacing: -0.408,
              ),
            ),
            const Spacer(),
            Text(
              emission,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (hasTable) ...[
          const SizedBox(height: 8),
          _buildCongestionTable(),
        ],
      ],
    );
  }

  Widget _buildCongestionTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF367970),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Congestion Level',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.408,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Speed (km/h)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.408,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Adjustment',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.408,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Divider
            Container(
              height: 1,
              color: const Color(0xFF121212),
            ),
            
            const SizedBox(height: 12),
            
            // Data rows
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildTableCell('Low'),
                      const SizedBox(height: 8),
                      _buildTableCell('Medium'),
                      const SizedBox(height: 8),
                      _buildTableCell('High'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildTableCell('≥ 60'),
                      const SizedBox(height: 8),
                      _buildTableCell('≥ 30 and <60'),
                      const SizedBox(height: 8),
                      _buildTableCell('< 30'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildTableCell('None'),
                      const SizedBox(height: 8),
                      _buildTableCell('+ 15%'),
                      const SizedBox(height: 8),
                      _buildTableCell('+ 40%'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        letterSpacing: -0.408,
        height: 2.0,
      ),
    );
  }
}
