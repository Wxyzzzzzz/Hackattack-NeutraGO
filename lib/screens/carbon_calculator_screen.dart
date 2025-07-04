import 'package:flutter/material.dart';
import 'carbon_calculator.dart';

import '../widgets/location_search_field.dart';

class CarbonCalculatorScreen extends StatefulWidget {
  const CarbonCalculatorScreen({super.key});

  @override
  State<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends State<CarbonCalculatorScreen> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  String? selectedTransportationMethod;
  bool _showCarbonFootprint = false;
  String _calculatedFootprint = "50g";

  final List<String> transportationMethods = [
    'Car',
    'Public Transport (MRT/LRT/KTM)',
    'Bicycle',
    'Walking',
    'Motorcycle',
    'Train',
    'Bus',
    'Electric Car'
  ];

  @override
  void dispose() {
    _startLocationController.dispose();
    _endLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E3),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF153462),
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Carbon Calculator',
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
                  // const SizedBox(width: 44), // Balance the back button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CarbonCalculator()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.calculate,
                        color: Color(0xFF153462),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Enter details title
                    Text(
                      'Enter the following details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth < 360 ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        letterSpacing: -0.408,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFDADADA),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Start Location
                          // _buildTextInputField(
                          //   'Start Location',
                          //   _startLocationController,
                          //   'Enter start location',
                          // ),
                          LocationSearchField(
                            controller: _startLocationController,
                            labelText: 'Start Location',
                            apiKey: 'AIzaSyCp0J_hsaPdeyjtkJrBw8bmXHYET4o75rQ',
                            onLocationSelected: (lat, lng, name) {
                              // Optional: Save to variable, marker, etc.
                              print("Start location: $name ($lat, $lng)");
                            },
                          ),
                          const SizedBox(height: 16),

                          // End Location
                          // _buildTextInputField(
                          //   'End Location',
                          //   _endLocationController,
                          //   'Enter end location',
                          // ),
                          LocationSearchField(
                            controller: _endLocationController,
                            labelText: 'Enter End Location',
                            apiKey: 'AIzaSyCp0J_hsaPdeyjtkJrBw8bmXHYET4o75rQ',
                            onLocationSelected: (lat, lng, name) {
                              print("End location: $name ($lat, $lng)");
                            },
                          ),
                          const SizedBox(height: 16),

                          // Transportation Method
                          _buildDropdownField(
                            'Transportation Method',
                            selectedTransportationMethod,
                            transportationMethods,
                            (String? value) {
                              setState(() {
                                selectedTransportationMethod = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitCalculation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22866E),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 360 ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            letterSpacing: -0.408,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Estimated Carbon Footprint (only show after submit)
                    if (_showCarbonFootprint) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFDADADA),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Estimated Carbon Footprint:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth < 360 ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                letterSpacing: -0.408,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _calculatedFootprint,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth < 360 ? 32 : 36,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                letterSpacing: -0.408,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField(
    String label,
    TextEditingController controller,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            letterSpacing: -0.408,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFBAD1C1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            letterSpacing: -0.408,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFBAD1C1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Select $label',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              dropdownColor: const Color(0xFFBAD1C1),
              borderRadius: BorderRadius.circular(15),
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  void _submitCalculation() {
    if (_startLocationController.text.isEmpty ||
        _endLocationController.text.isEmpty ||
        selectedTransportationMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Calculate carbon footprint based on transportation method
    _calculatedFootprint = _calculateCarbonFootprint(
      _startLocationController.text,
      _endLocationController.text,
      selectedTransportationMethod!,
    );

    setState(() {
      _showCarbonFootprint = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Carbon footprint calculated: $_calculatedFootprint',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: const Color(0xFF22866E),
      ),
    );
  }

  String _calculateCarbonFootprint(
      String startLocation, String endLocation, String transportMethod) {
    // Simple calculation logic - in a real app, this would use actual APIs and distance calculations
    Map<String, double> emissionFactors = {
      'Car': 120.0,
      'Public Transport': 45.0,
      'Bicycle': 0.0,
      'Walking': 0.0,
      'Motorcycle': 80.0,
      'Train': 35.0,
      'Bus': 50.0,
      'Electric Car': 30.0,
    };

    // Mock distance calculation based on location names length (for demo purposes)
    double estimatedDistance =
        (startLocation.length + endLocation.length) * 2.0;
    double emissionFactor = emissionFactors[transportMethod] ?? 100.0;
    double carbonFootprint = (estimatedDistance * emissionFactor) / 100;

    return '${carbonFootprint.toInt()}g';
  }
}
