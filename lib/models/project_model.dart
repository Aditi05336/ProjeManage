class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String colorHex;
  final DateTime deadline;
  final List<String> memberIds;
  final String createdById;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
    required this.deadline,
    required this.memberIds,
    required this.createdById,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'colorHex': colorHex,
      'deadline': deadline.toIso8601String(),
      'memberIds': memberIds,
      'createdById': createdById,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProjectModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      colorHex: map['colorHex'] ?? '#FFFFFF',
      deadline: map['deadline'] != null 
          ? DateTime.parse(map['deadline']) 
          : DateTime.now(),
      memberIds: List<String>.from(map['memberIds'] ?? []),
      createdById: map['createdById'] ?? '',
    );
  }
}
