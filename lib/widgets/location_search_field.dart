import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String apiKey;
  final Function(double lat, double lng, String name)? onLocationSelected;

  const LocationSearchField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.apiKey,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final FocusNode _focusNode = FocusNode();
  List<dynamic> _predictions = [];
  bool _showSuggestions = false;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _fieldKey = GlobalKey();

  // Future<void> _searchPlaces(String input) async {
  //   if (input.isEmpty) {
  //     setState(() {
  //       _predictions = [];
  //       _showSuggestions = false;
  //     });
  //     return;
  //   }

  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}&components=country:my';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     setState(() {
  //       _predictions = data['predictions'];
  //       _showSuggestions = true;
  //     });
  //   }
  // }

  Future<void> _selectPrediction(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${widget.apiKey}';
    final detailsResponse = await http.get(Uri.parse(detailsUrl));
    if (detailsResponse.statusCode == 200) {
      final details = json.decode(detailsResponse.body);
      final location = details['result']['geometry']['location'];
      final name = details['result']['name'];
      final lat = location['lat'];
      final lng = location['lng'];

      setState(() {
        widget.controller.text = name;
        _predictions.clear();
        _showSuggestions = false;
      });

      _focusNode.unfocus();

      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(lat, lng, name);
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       TextField(
  //         controller: widget.controller,
  //         focusNode: _focusNode,
  //         decoration: InputDecoration(
  //           hintText: widget.labelText,
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //           filled: true,
  //           fillColor: const Color(0xFFD9D9D9),
  //           prefixIcon: const Icon(Icons.place_outlined, color: Colors.black54),
  //         ),
  //         onChanged: _searchPlaces,
  //       ),
  //       if (_showSuggestions && _predictions.isNotEmpty)
  //         Container(
  //           height: 200,
  //           margin: const EdgeInsets.only(top: 8),
  //           padding: const EdgeInsets.symmetric(horizontal: 8),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: const [
  //               BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
  //             ],
  //           ),
  //           child: ListView.builder(
  //             itemCount: _predictions.length,
  //             itemBuilder: (context, index) {
  //               final prediction = _predictions[index];
  //               return ListTile(
  //                 title: Text(prediction['description']),
  //                 onTap: () => _selectPrediction(prediction),
  //               );
  //             },
  //           ),
  //         ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),

        // Wrap in CompositedTransformTarget for floating overlay
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            key: _fieldKey,
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
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.place_outlined, color: Colors.black54),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      _searchPlaces(value);
                    },
                    onTap: () {
                      if (_predictions.isNotEmpty) _showOverlay();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search location',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(right: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showOverlay() {
    _removeOverlay(); // prevent duplicates

    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  title: Text(
                    prediction['description'],
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onTap: () {
                    _selectPrediction(prediction);
                    _removeOverlay();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      _removeOverlay();
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}&components=country:my';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _predictions = data['predictions'];
      });
      if (_predictions.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      _removeOverlay();
    }
  }





  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Label (optional — remove if not needed)
  //       Text(
  //         widget.labelText,
  //         style: const TextStyle(
  //           color: Colors.black,
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: 'Poppins',
  //           letterSpacing: -0.408,
  //         ),
  //       ),
  //       const SizedBox(height: 8),

  //       // Styled text field with location icon
  //       Container(
  //         width: double.infinity,
  //         height: 48,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15),
  //           color: const Color(0xFFBAD1C1),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.25),
  //               offset: const Offset(0, 4),
  //               blurRadius: 4,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 12.0),
  //               child: Icon(Icons.place_outlined, color: Colors.black54),
  //             ),
  //             Expanded(
  //               child: TextField(
  //                 controller: widget.controller,
  //                 focusNode: _focusNode,
  //                 onChanged: _searchPlaces,
  //                 style: const TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 14,
  //                   fontFamily: 'Poppins',
  //                 ),
  //                 decoration: const InputDecoration(
  //                   hintText: 'Search location',
  //                   hintStyle: TextStyle(
  //                     color: Colors.black54,
  //                     fontSize: 14,
  //                     fontFamily: 'Poppins',
  //                   ),
  //                   border: InputBorder.none,
  //                   contentPadding: EdgeInsets.only(right: 16.0),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),

  //       // Suggestions dropdown
  //       if (_showSuggestions && _predictions.isNotEmpty)
  //         Container(
  //           margin: const EdgeInsets.only(top: 8),
  //           padding: const EdgeInsets.symmetric(horizontal: 8),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 blurRadius: 8,
  //                 offset: Offset(0, 2),
  //               ),
  //             ],
  //           ),
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: _predictions.length,
  //             itemBuilder: (context, index) {
  //               final prediction = _predictions[index];
  //               return ListTile(
  //                 title: Text(
  //                   prediction['description'],
  //                   style: const TextStyle(
  //                     fontFamily: 'Poppins',
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //                 onTap: () => _selectPrediction(prediction),
  //               );
  //             },
  //           ),
  //         ),
  //     ],
  //   );
  // }
}