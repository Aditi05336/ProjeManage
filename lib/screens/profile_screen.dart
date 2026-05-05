import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../theme/theme_manager.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _authService.currentUser;
    if (user != null) {
      final profile = await _authService.getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userProfile?['name'] ?? 'Loading...';
    final userEmail = _userProfile?['email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0B95FF)))
          : ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFE3F2FD),
                  child: const Icon(Icons.person, size: 50, color: Color(0xFF0B95FF)),
                ),
                const SizedBox(height: 24),
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFF0B95FF)),
                  title: Text('Edit Profile', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    if (_userProfile != null) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(userProfile: _userProfile!),
                        ),
                      );
                      // If updated successfully, reload profile
                      if (result == true) {
                        setState(() {
                          _isLoading = true;
                        });
                        _loadUserProfile();
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: Color(0xFF0B95FF)),
                  title: Text('Dark Mode', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                  trailing: ValueListenableBuilder<ThemeMode>(
                    valueListenable: ThemeManager.themeModeNotifier,
                    builder: (_, currentMode, __) {
                      return Switch(
                        value: currentMode == ThemeMode.dark,
                        onChanged: (val) {
                          ThemeManager.toggleTheme();
                        },
                        activeColor: const Color(0xFF0B95FF),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                  title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.redAccent)),
                  onTap: () async {
                    await _authService.signOut();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
                    }
                  },
                ),
              ],
            ),
    );
  }
}
