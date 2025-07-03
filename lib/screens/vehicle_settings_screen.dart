import 'package:flutter/material.dart';

class VehicleSettingsScreen extends StatefulWidget {
  const VehicleSettingsScreen({super.key});

  @override
  State<VehicleSettingsScreen> createState() => _VehicleSettingsScreenState();
}

class _VehicleSettingsScreenState extends State<VehicleSettingsScreen> {
  String? selectedCurrentVehicle;
  String? selectedVehicleType;
  String? selectedCarBrand;
  String? selectedModelName;

  final List<String> curCar = ['Car - Toyota Vios', 'Car - Honda Civic'];
  final List<String> carType = ['Petrol', 'Hybrid', 'Electric Vehicle (EV)'];
  final List<String> vehicleTypes = ['Car', 'Motorcycle', 'Truck', 'SUV'];
  final List<String> carBrands = ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Audi'];
  final List<String> modelNames = ['Camry', 'Civic', 'X3', 'C-Class', 'A4'];

  @override
  void initState() {
    super.initState();
    selectedCurrentVehicle = curCar.first;
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      'Vehicle Settings',
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
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Current vehicle type section
                    Text(
                      'Your current vehicle type:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth < 360 ? 18 : 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        letterSpacing: -0.408,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Current vehicle dropdown
                    Container(
                      width: double.infinity,
                      height: 61,
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
                          value: selectedCurrentVehicle,
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Select current vehicle',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          items: curCar.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCurrentVehicle = newValue;
                            });
                          },
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          dropdownColor: const Color(0xFFBAD1C1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Add new vehicle section
                    Text(
                      'Add new vehicle:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth < 360 ? 18 : 20,
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
                          // Vehicle Type
                          _buildFormField(
                            'Vehicle Type',
                            selectedVehicleType,
                            vehicleTypes,
                            (String? value) {
                              setState(() {
                                selectedVehicleType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Car Brand
                          _buildFormField(
                            'Car Brand',
                            selectedCarBrand,
                            carBrands,
                            (String? value) {
                              setState(() {
                                selectedCarBrand = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Model Name
                          _buildFormField(
                            'Model Name',
                            selectedModelName,
                            modelNames,
                            (String? value) {
                              setState(() {
                                selectedModelName = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Add New Vehicle Button
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: () {
                          _addNewVehicle();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22866E),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add New Vehicle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth < 360 ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                letterSpacing: -0.408,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
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

  Widget _buildFormField(
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

  void _addNewVehicle() {
    if (selectedVehicleType != null && 
        selectedCarBrand != null && 
        selectedModelName != null) {
      // Process the new vehicle data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added: $selectedVehicleType - $selectedCarBrand $selectedModelName',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: const Color(0xFF22866E),
        ),
      );
      
      // Reset form
      setState(() {
        selectedVehicleType = null;
        selectedCarBrand = null;
        selectedModelName = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all fields',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
