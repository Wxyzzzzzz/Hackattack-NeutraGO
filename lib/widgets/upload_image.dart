// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class ImgurUploadDemo extends StatefulWidget {
//   const ImgurUploadDemo({super.key});

//   @override
//   State<ImgurUploadDemo> createState() => _ImgurUploadDemoState();
// }

// class _ImgurUploadDemoState extends State<ImgurUploadDemo> {
//   String? _uploadedImageUrl;

//   Future<void> uploadImageToImgur() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile == null) return;

//     final imageFile = File(pickedFile.path);
//     final imageBytes = await imageFile.readAsBytes();
//     final base64Image = base64Encode(imageBytes);

//     const clientId = 'YOUR_IMGUR_CLIENT_ID'; // Replace this with your actual Imgur Client ID

//     final response = await http.post(
//       Uri.parse('https://api.imgur.com/3/image'),
//       headers: {
//         'Authorization': 'Client-ID $clientId',
//       },
//       body: {
//         'image': base64Image,
//       },
//     );

//     final data = jsonDecode(response.body);
//     if (response.statusCode == 200 && data['success']) {
//       setState(() {
//         _uploadedImageUrl = data['data']['link'];
//       });
//       print('Uploaded image URL: $_uploadedImageUrl');
//     } else {
//       print('Upload failed: ${data['data']['error']}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed: ${data['data']['error']}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload to Imgur')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: uploadImageToImgur,
//               child: const Text('Pick & Upload Image'),
//             ),
//             const SizedBox(height: 20),
//             if (_uploadedImageUrl != null)
//               Column(
//                 children: [
//                   const Text('Uploaded Image:'),
//                   const SizedBox(height: 10),
//                   Image.network(_uploadedImageUrl!),
//                   SelectableText(_uploadedImageUrl!),
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
