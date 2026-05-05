import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import 'task_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts & Due Tasks', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 1,
      ),
      body: user == null
          ? const Center(child: Text("Please sign in"))
          : StreamBuilder<List<TaskModel>>(
              stream: DatabaseService().getUserTasks(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF0B95FF)));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No active alerts',
                          style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                // Filter tasks to show ones that are incomplete and either due today or overdue
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                
                final activeAlerts = snapshot.data!.where((t) {
                  if (t.status == 'done') return false;
                  final due = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
                  return due.isBefore(today.add(const Duration(days: 3))); // Due in next 3 days or overdue
                }).toList();

                // Sort by due date (closest first)
                activeAlerts.sort((a, b) => a.dueDate.compareTo(b.dueDate));

                if (activeAlerts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 80, color: Colors.green.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'You are all caught up!',
                          style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeAlerts.length,
                  itemBuilder: (context, index) {
                    final task = activeAlerts[index];
                    final isOverdue = task.dueDate.isBefore(today);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isOverdue ? Colors.redAccent.withAlpha(50) : Colors.transparent),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: isOverdue ? Colors.redAccent.withAlpha(20) : Colors.orange.withAlpha(20),
                          child: Icon(
                            isOverdue ? Icons.warning_amber_rounded : Icons.access_time_rounded,
                            color: isOverdue ? Colors.redAccent : Colors.orange,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            isOverdue 
                                ? "Overdue! Was due ${task.dueDate.toLocal()}".split(' ')[0]
                                : "Due soon: ${task.dueDate.toLocal()}".split(' ')[0],
                            style: GoogleFonts.inter(
                              color: isOverdue ? Colors.redAccent : Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
