import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String _currentStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _currentStatus = newStatus;
      _isLoading = true;
    });

    try {
      final updatedTask = TaskModel(
        id: widget.task.id,
        projectId: widget.task.projectId,
        title: widget.task.title,
        description: widget.task.description,
        status: newStatus,
        priority: widget.task.priority,
        dueDate: widget.task.dueDate,
        assignedTo: widget.task.assignedTo,
        createdById: widget.task.createdById,
      );
      
      await DatabaseService().updateTask(updatedTask);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task status updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color priorityColor = Colors.green;
    if (widget.task.priority == 'high') priorityColor = Colors.red;
    if (widget.task.priority == 'medium') priorityColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              await DatabaseService().deleteTask(widget.task.id);
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.task.priority.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: priorityColor),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "${widget.task.dueDate.toLocal()}".split(' ')[0],
                      style: GoogleFonts.inter(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.task.title,
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.task.description.isNotEmpty ? widget.task.description : 'No description provided.',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade800, height: 1.5),
            ),
            const SizedBox(height: 40),
            Text('Update Status', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF0B95FF)))
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusButton('To Do', 'todo', Colors.grey.shade600),
                  _buildStatusButton('In Progress', 'in_progress', const Color(0xFF0B95FF)),
                  _buildStatusButton('Done', 'done', const Color(0xFF34C759)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String value, Color color) {
    final isSelected = _currentStatus == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _updateStatus(value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withAlpha(20),
            border: Border.all(color: isSelected ? color : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
