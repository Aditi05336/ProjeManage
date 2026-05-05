class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String status; // 'todo', 'in_progress', 'done'
  final String priority; // 'low', 'medium', 'high'
  final DateTime dueDate;
  final List<String> assignedTo; // List of user IDs
  final String createdById;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.assignedTo,
    required this.createdById,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'assignedTo': assignedTo,
      'createdById': createdById,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      projectId: map['projectId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'todo',
      priority: map['priority'] ?? 'low',
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : DateTime.now(),
      assignedTo: List<String>.from(map['assignedTo'] ?? []),
      createdById: map['createdById'] ?? '',
    );
  }
}
