class User {
  String id;
  final String profilepic;
  final String name;
  final String username;
  List<String> likedPosts = [];
  final String batch;
  final String about;

  User({required this.name, required this.profilepic, required this.username, this.id = '', required this.about, required this.batch});

  factory User.fromdummyData() {
    User user = User(
        name: 'Aniket Raj',
        profilepic:
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        username: 'grimreaperLinux',
        id: 'this_is_a_special_id',
        batch: '2024',
        about: 'Genius, Billionaire, Playboy, Philanthropist');

    user.likedPosts = [];

    return user;
  }
}
