class Community {
  final String name;
  final String image;
  final int activeMembers;
  final String bio;

  Community(
      {required this.name,
      required this.bio,
      required this.image,
      required this.activeMembers});

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      image: map['image'] ?? '',
      activeMembers: map['activeMembers'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'image': image,
      'activeMembers': activeMembers,
    };
  }
}
