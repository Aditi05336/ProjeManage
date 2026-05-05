import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import 'task_detail_screen.dart';

class KanbanBoardScreen extends StatelessWidget {
  final ProjectModel project;

  const KanbanBoardScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: const Color(0xFF0B95FF),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF0B95FF),
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'To Do'),
              Tab(text: 'In Progress'),
              Tab(text: 'Done'),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<TaskModel>>(
              stream: DatabaseService().getProjectTasks(project.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF0B95FF)));
                }

                final tasks = snapshot.data ?? [];
                
                final todoTasks = tasks.where((t) => t.status == 'todo').toList();
                final inProgressTasks = tasks.where((t) => t.status == 'in_progress').toList();
                final doneTasks = tasks.where((t) => t.status == 'done').toList();

                return TabBarView(
                  children: [
                    _buildTaskList(context, todoTasks, 'todo'),
                    _buildTaskList(context, inProgressTasks, 'in_progress'),
                    _buildTaskList(context, doneTasks, 'done'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskModel> tasks, String status) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No tasks here', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        Color priorityColor = Colors.green;
        if (task.priority == 'high') priorityColor = Colors.red;
        if (task.priority == 'medium') priorityColor = Colors.orange;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              task.title,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.priority.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: priorityColor),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${task.dueDate.toLocal()}".split(' ')[0],
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
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
  }
}
