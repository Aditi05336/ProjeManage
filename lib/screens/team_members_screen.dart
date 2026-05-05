import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class TeamMembersScreen extends StatefulWidget {
  final ProjectModel project;

  const TeamMembersScreen({super.key, required this.project});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _inviteMember() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Basic mock invite logic: normally you'd search for the user by email,
      // and add their UID to the project.memberIds list.
      // Since this is a simple implementation, we'll just show a snackbar.
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation sent to $email (Mock)')),
      );
      _emailController.clear();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Members', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invite Member', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _inviteMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B95FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Send', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text('Current Members', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.project.memberIds.length,
                itemBuilder: (context, index) {
                  final memberId = widget.project.memberIds[index];
                  return FutureBuilder<UserModel?>(
                    future: DatabaseService().getUser(memberId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text('Loading...'));
                      }
                      
                      final user = snapshot.data;
                      if (user == null) {
                        return const ListTile(title: Text('Unknown User'));
                      }

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE3F2FD),
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: GoogleFonts.inter(color: const Color(0xFF0B95FF), fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        subtitle: Text(user.email, style: GoogleFonts.inter(color: Colors.grey.shade600)),
                        trailing: memberId == widget.project.createdById 
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('Admin', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0B95FF), fontWeight: FontWeight.bold)),
                            )
                          : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
