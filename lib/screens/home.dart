// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F2E4),
//       appBar: AppBar(
//         title: const Text('Welcome to NeutraGO'),
//         backgroundColor: const Color(0xFF153462),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService().signOut();
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (user?.photoURL != null)
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(user!.photoURL!),
//               ),
//             const SizedBox(height: 20),
//             Text(
//               'Welcome, ${user?.displayName ?? user?.email ?? 'User'}!',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF153462),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'You are successfully signed in!',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFF707070),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }