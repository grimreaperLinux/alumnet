class User {
  final String id;
  final String profilepic;
  final String name;
  final String username;
  List<String> likedPosts = [];
  final String batch;
  final String about;
  final String branch;

  User({required this.name, required this.profilepic, required this.username, required this.about, required this.batch, required this.branch, required this.id});

  factory User.fromdummyData() {
    User user = User(
        name: 'Aniket Raj',
        profilepic:
            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
        username: 'grimreaperLinux',
        id: 'this_is_a_special_id',
        batch: '2024',
        about: 'Genius, Billionaire, Playboy, Philanthropist',
      branch: "DSAI");

    user.likedPosts = [];

    return user;
  }
}
