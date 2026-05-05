class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePic;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'],
    );
  }
}
