import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import 'kanban_board_screen.dart';
import 'team_members_screen.dart';
import 'create_task_screen.dart';
import 'edit_project_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(project.colorHex.replaceAll('#', '0xFF')));

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TeamMembersScreen(project: project)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProjectScreen(project: project)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Project Header Info
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Due Date', style: GoogleFonts.inter(color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                    Text(
                      "${project.deadline.toLocal()}".split(' ')[0],
                      style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  project.description.isNotEmpty ? project.description : 'No description provided.',
                  style: GoogleFonts.inter(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),
                // Quick stats (placeholder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('To Do', '0', Colors.grey.shade600),
                    _buildStatColumn('In Progress', '0', const Color(0xFF0B95FF)),
                    _buildStatColumn('Done', '0', const Color(0xFF34C759)),
                  ],
                )
              ],
            ),
          ),
          // Kanban Board Area
          Expanded(
            child: KanbanBoardScreen(project: project),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTaskScreen(projectId: project.id)),
          );
        },
        backgroundColor: const Color(0xFF0B95FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
