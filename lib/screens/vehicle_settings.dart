import 'package:flutter/material.dart';

class VehicleSettingsScreen extends StatefulWidget {
  const VehicleSettingsScreen({super.key});

  @override
  State<VehicleSettingsScreen> createState() => _VehicleSettingsScreenState();
}

class _VehicleSettingsScreenState extends State<VehicleSettingsScreen> {
  String? selectedCurrentVehicle;
  String? selectedVehicleType;
  String? selectedCarType;
  String? selectedCarBrand;
  String? selectedModelName;

  

  final List<String> carTypes = ['Petrol', 'Hybrid', 'Electric Vehicle (EV)'];
  final List<String> vehicleTypes = ['Car', 'Motorcycle', 'Truck', 'SUV'];
  final Map<String, List<String>> vehicleBrandMap = {
    'Car': ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Audi', 'Tesla'],
    'Motorcycle': ['Yamaha', 'Honda', 'Kawasaki', 'Ducati', 'Vespa'],
    'Truck': ['Ford', 'Isuzu', 'Volvo'],
    'SUV': ['Toyota', 'Hyundai', 'BMW', 'Mercedes', 'Kia'],
  };

  final Map<String, List<String>> brandModelMap = {
  'Toyota': ['Vios', 'Camry', 'Corolla'],
  'Honda': ['Civic', 'Accord', 'CBR'],
  'BMW': ['X3', 'X5', 'i8'],
  'Yamaha': ['R15', 'MT-15'],
  'Ducati': ['Panigale', 'Monster'],
  'Ford': ['F-150', 'Ranger'],
  'Isuzu': ['D-Max'],
  'Volvo': ['FH16'],
  'Hyundai': ['Tucson', 'Santa Fe'],
  'Kia': ['Seltos', 'Sportage'],
  // 'Mercedes':
  // 'Kawasaki':
  // 'Vespa':
  // 'Audi':
  // 'Tesla':
};
  // final Map<String, List<String>> typeOptions = {
  //   'Car': ['Petrol', 'Hybrid', 'Electric (EV)'],
  //   'Motorcycle': ['Petrol', 'Electric'],
  //   'Truck': ['Diesel', 'Electric'],
  //   'SUV': ['Petrol', 'Hybrid', 'Electric (EV)'],
  // };
  // final List<String> carBrands = ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Audi'];
  // final List<String> modelNames = ['Camry', 'Civic', 'X3', 'C-Class', 'A4'];

  List<String> curCar = ['Car - Toyota Vios', 'Car - Honda Civic'];

  @override
  void initState() {
    super.initState();
    selectedCurrentVehicle = curCar.first; // Default to first current vehicle
  }

  @override
  Widget build(BuildContext context) {
    // final brandList = selectedVehicleType != null ? brandOptions[selectedVehicleType]! : [];
    // final typeList = selectedVehicleType != null ? typeOptions[selectedVehicleType]! : [];

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E3),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screenWidth),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSectionTitle('Your current available vehicle(s):', screenWidth),
                    const SizedBox(height: 16),
                    _buildDropdownContainer(
                      selectedCurrentVehicle,
                      curCar,
                      (String? newValue) {
                        setState(() {
                          selectedCurrentVehicle = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Add new vehicle:', screenWidth),
                    const SizedBox(height: 16),
                    _buildNewVehicleForm(),
                    const SizedBox(height: 32),
                    _buildAddVehicleButton(screenWidth),
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

  Widget _buildHeader(double screenWidth) {
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
          const SizedBox(width: 44), // Balance
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: screenWidth < 360 ? 18 : 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        letterSpacing: -0.408,
      ),
    );
  }

  Widget _buildDropdownContainer(String? selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return Padding( 
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
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
            value: selectedValue,
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
            items: options.map((String value) {
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
            onChanged: onChanged,
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
    );
  }

  Widget _buildNewVehicleForm() {
    final List<String> availableBrands = selectedVehicleType != null
      ? vehicleBrandMap[selectedVehicleType!] ?? []
      : [];

  final List<String> availableModels = selectedCarBrand != null
      ? brandModelMap[selectedCarBrand!] ?? []
      : [];

    return Container(
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
          _buildFormField(
            'Vehicle Type', 
            selectedVehicleType, 
            vehicleBrandMap.keys.toList(), 
            (value) {
            setState(() {
              // selectedVehicleType = value;
              // selectedCarType = null; // reset car type if vehicle changed
              selectedVehicleType = value;
              selectedCarBrand = null;
              selectedModelName = null;
            });
          }),

          if (selectedVehicleType == 'Car') ...[
            const SizedBox(height: 16),
            _buildFormField('Car Type', selectedCarType, carTypes, (value) {
              setState(() {
                selectedCarType = value;
              });
            }),
          ],
          const SizedBox(height: 16),

          // Brand dropdown updates based on vehicle type
          if (selectedVehicleType != null) ...[
            _buildFormField(
              'Car Brand',
              selectedCarBrand,
              availableBrands,
              (value) {
                setState(() {
                  selectedCarBrand = value;
                  selectedModelName = null;
                });
              },
            ),
            const SizedBox(height: 16),
          ],

          // Model dropdown updates based on brand
          if (selectedCarBrand != null) ...[
            _buildFormField(
              'Model Name',
              selectedModelName,
              availableModels,
              (value) {
                setState(() {
                  selectedModelName = value;
                });
              },
            ),
          ],

          // _buildFormField('Car Brand', selectedCarBrand, brandList, (value) {
          //   setState(() {
          //     selectedCarBrand = value;
          //   });
          // }),
          // const SizedBox(height: 16),
          // _buildFormField('Model Name', selectedModelName, typeList, (value) {
          //   setState(() {
          //     selectedModelName = value;
          //   });
          // }),
        ],
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

  Widget _buildAddVehicleButton(double screenWidth) {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton(
        onPressed: _addNewVehicle,
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
            const Icon(Icons.add, color: Colors.white, size: 24),
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
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          hint: Text('Select $label'),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _addNewVehicle() {
    final isCar = selectedVehicleType == 'Car';
    // final carTypeStr = isCar && selectedCarType != null ? ' - $selectedCarType' : '';

    if (selectedVehicleType != null &&
        (isCar ? selectedCarType != null : true) &&
        selectedCarBrand != null &&
        selectedModelName != null) {
      final newVehicle = '$selectedVehicleType - $selectedCarBrand $selectedModelName';

      setState(() {
        curCar.add(newVehicle);
        selectedCurrentVehicle = newVehicle;
        selectedVehicleType = null;
        selectedCarType = null;
        selectedCarBrand = null;
        selectedModelName = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added: $newVehicle',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: const Color(0xFF22866E),
        ),
      );
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

