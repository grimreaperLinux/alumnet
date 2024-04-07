class UserModel {
  final String instituteId;
  final String fullName;
  final String email;
  final String password;

  const UserModel({
    required this.instituteId,
    required this.fullName,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      'instituteId': instituteId,
      'fullName': fullName,
      'email': email,
    };
  }
}
