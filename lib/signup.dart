// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'services/auth_service.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _signUpWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final result = await _authService.signInWithGoogle();
//       if (result == null) {
//         // User cancelled or error occurred
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Sign up cancelled or failed')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _signUpWithEmail() async {
//     if (_emailController.text.isEmpty ||
//         _usernameController.text.isEmpty ||
//         _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }

//     if (_passwordController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password must be at least 6 characters')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final result = await _authService.createUserWithEmailAndPassword(
//         _emailController.text,
//         _passwordController.text,
//       );

//       if (result == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to create account')),
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Account created successfully!')),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F2E4),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 24),
//                 // Title
//                 const Text(
//                   'Create Account',
//                   style: TextStyle(
//                     color: Color(0xFF153462),
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     height: 0.81,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // App Logo
//                 Container(
//                   width: 266,
//                   height: 266,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF3F2E4),
//                     borderRadius: BorderRadius.circular(400),
//                   ),
//                   child: Image.network(
//                     'https://cdn.builder.io/api/v1/assets/b98029e88fcf4db8aa49aeb4cfd4d79e/chatgpt-image-jun-4-2025-09_28_22-pm-78090a?format=webp&width=800',
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Icon(
//                         Icons.eco,
//                         size: 120,
//                         color: Color(0xFF7A9B5A),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 60),
//                 // Email Field
//                 Container(
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(100),
//                     border: Border.all(color: const Color(0xFFCCD6DD)),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x40000000),
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       hintText: 'Email Address',
//                       hintStyle: TextStyle(
//                         color: Color(0xFF707070),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Username Field
//                 Container(
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(100),
//                     border: Border.all(color: const Color(0xFFCCD6DD)),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x40000000),
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _usernameController,
//                     decoration: const InputDecoration(
//                       hintText: 'Username',
//                       hintStyle: TextStyle(
//                         color: Color(0xFF707070),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Password Field
//                 Container(
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(100),
//                     border: Border.all(color: const Color(0xFFCCD6DD)),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x40000000),
//                         offset: Offset(0, 4),
//                         blurRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _passwordController,
//                     obscureText: !_isPasswordVisible,
//                     decoration: InputDecoration(
//                       hintText: 'Password',
//                       hintStyle: const TextStyle(
//                         color: Color(0xFF707070),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 18,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isPasswordVisible
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.black,
//                           size: 19,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isPasswordVisible = !_isPasswordVisible;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // Sign Up Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _signUpWithEmail,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF153462),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                         : const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               height: 1.5,
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Google Sign-Up Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton.icon(
//                     onPressed: _isLoading ? null : _signUpWithGoogle,
//                     icon: Image.network(
//                       'https://developers.google.com/identity/images/g-logo.png',
//                       height: 24,
//                       width: 24,
//                     ),
//                     label: const Text(
//                       'Sign up with Google',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black87,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                         side: const BorderSide(color: Color(0xFFCCD6DD)),
//                       ),
//                       elevation: 0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Login Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Already have an account? ',
//                       style: TextStyle(
//                         color: Color(0xFF707070),
//                         fontSize: 14,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Color(0xFF153462),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
