import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _darkMode = true;
  final AuthService _authService = AuthService();

  Future<void> _signOut() async {
    try {
      await _authService.signOut();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print("❌ Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // Header with green background
          Container(
            width: double.infinity,
            height: 115,
            decoration: const BoxDecoration(
              color: Color(0xFF367970),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.035,
                        fontFamily: 'Rubik',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content with white card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B4B4B).withOpacity(0.15),
                      offset: const Offset(0, 2),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User profile section
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1F436D)
                                        .withOpacity(0.25),
                                    offset: const Offset(0, 4),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: user?.photoURL != null
                                    ? Image.network(
                                        user!.photoURL!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                _buildDefaultAvatar(),
                                      )
                                    : _buildDefaultAvatar(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              user?.displayName ?? 'user1',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Rubik',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Account Settings section
                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            color: Color(0xFFADADAD),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        const SizedBox(height: 21),

                        // Edit profile
                        _buildMenuItem(
                          'Edit profile',
                          Icons.keyboard_arrow_right,
                          onTap: () {
                            // Navigate to edit profile screen
                          },
                        ),
                        const SizedBox(height: 21),

                        // Change password
                        _buildMenuItem(
                          'Change password',
                          Icons.keyboard_arrow_right,
                          onTap: () {
                            // Navigate to change password screen
                          },
                        ),
                        const SizedBox(height: 21),

                        // Add payment method
                        _buildMenuItem(
                          'Add a payment method',
                          Icons.add,
                          onTap: () {
                            // Navigate to add payment method screen
                          },
                        ),
                        const SizedBox(height: 21),

                        // Push notifications toggle
                        _buildToggleItem(
                          'Push notifications',
                          _pushNotifications,
                          (value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                          },
                        ),
                        const SizedBox(height: 21),

                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFCACACA),
                        ),
                        const SizedBox(height: 30),

                        // More section
                        const Text(
                          'More',
                          style: TextStyle(
                            color: Color(0xFFADADAD),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // About us
                        _buildMenuItem(
                          'About us',
                          Icons.keyboard_arrow_right,
                          onTap: () {
                            // Navigate to about us screen
                          },
                        ),
                        const SizedBox(height: 24),

                        // Privacy policy
                        _buildMenuItem(
                          'Privacy policy',
                          Icons.keyboard_arrow_right,
                          onTap: () {
                            // Navigate to privacy policy screen
                          },
                        ),
                        const SizedBox(height: 24),

                        // Terms and conditions
                        _buildMenuItem(
                          'Terms and conditions',
                          Icons.keyboard_arrow_right,
                          onTap: () {
                            // Navigate to terms and conditions screen
                          },
                        ),
                        const SizedBox(height: 40),

                        // Sign out button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _signOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF153462),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFE57373),
        shape: BoxShape.circle,
      ),
      child: Image.network(
        'https://cdn.builder.io/api/v1/image/assets%2F913aa688c53349a2a4d6dd5a8e815215%2Fdf3233619e9844f7afa240c23cafae1e?format=webp&width=800',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.person,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Rubik',
            ),
          ),
          const Spacer(),
          Icon(
            icon,
            color: const Color(0xFF4B4B4B),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Rubik',
          ),
        ),
        const Spacer(),
        Container(
          width: 56,
          height: 29,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: value ? const Color(0xFF367970) : const Color(0xFFEAEAEA),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: value ? 30 : 4,
                top: 4,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onChanged(!value),
                  child: const SizedBox(
                    width: 56,
                    height: 29,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
