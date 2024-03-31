import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User currentUser = User(
      id: '8BICx4WqZatmhFNsgmDZ',
      batch: '2024',
      username: "20bds016",
      name: "Chirag",
      about: "Hello User",
      profilepic:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlcnxlbnwwfHwwfHx8MA%3D%3D',
      branch: 'DSAI');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Divider(
                        thickness: 1,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            currentUser.profilepic,
                          ) // Replace with your image
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currentUser.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditProfileModal(
                                currentUser: currentUser,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Capsule shape
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10)),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '@${currentUser.username}',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      '${currentUser.about}',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      overflow: TextOverflow
                          .ellipsis, // Display ellipsis when overflowing
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.calendar_month),
                        ),
                        Text(
                          'Batch ${currentUser.batch}',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(flex: 6, child: TabBarExample()),
        ],
      ),
    );
  }
}

class TabBarExample extends StatelessWidget {
  TabBarExample({super.key});
  List<Map<String, dynamic>> posts = [
    {
      'profileImageUrl':
          'https://media.istockphoto.com/id/1432226243/photo/happy-young-woman-of-color-smiling-at-the-camera-in-a-studio.jpg?s=612x612&w=0&k=20&c=rk75Rl4PTtXbEyj7RgSz_pJPlgEpUEsgcJVNGQZbrMw=',
      'name': 'Chirag Mittal',
      'username': 'chiragmittal',
      'postedAt': DateTime.now().subtract(Duration(days: 2, hours: 1 * 2)),
      'postContent':
          'This is post number 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'likes': 10 + 1 * 2,
      'comments': 5 + 1,
      'views': 100 + 1 * 10,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(
                height: 30,
              ), // Adjust the height as needed
              child: TabBar(
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Mentions'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostWidget(
                          profileImageUrl: posts[index]['profileImageUrl'],
                          name: posts[index]['name'],
                          username: posts[index]['username'],
                          postedAt: posts[index]['postedAt'],
                          postContent: posts[index]['postContent'],
                          likes: posts[index]['likes'],
                          comments: posts[index]['comments'],
                          views: posts[index]['views'],
                        );
                      },
                    ),
                  ),
                  Center(child: Text('Content for Tab 2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String username;
  final DateTime postedAt;
  final String postContent;
  final int likes;
  final int comments;
  final int views;

  const PostWidget({
    required this.profileImageUrl,
    required this.name,
    required this.username,
    required this.postedAt,
    required this.postContent,
    required this.likes,
    required this.comments,
    required this.views,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.17,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
          SizedBox(width: 16.0),
          // Post Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, Username, and Posted Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '$name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' @$username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' • ${_getTimeAgo(postedAt)} ago',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // Post Content
                Text(
                  postContent,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.0),
                // Likes, Comments, Views
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite),
                        Text('$likes'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.comment),
                        Text('$comments'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.visibility),
                        Text('$views'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate time ago
  String _getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return 'Just now';
    }
  }
}

class EditProfileModal extends StatefulWidget {
  final User currentUser;
  EditProfileModal({required this.currentUser});

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  TextEditingController _aboutController = TextEditingController();
  String _currentProfilePic = 'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';
  var _isUploadingFile = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutController = TextEditingController(text: widget.currentUser.about);
    setState(() {
      _currentProfilePic = widget.currentUser.profilepic;
    });
  }

  Future<String>_handlerProfilePicUpload(File file)async{
    var rng = Random();
    Reference storageReference = FirebaseStorage.instance.ref().child('profile/${widget.currentUser.id}-${rng.nextInt(999999)}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _handlerEditProfile()async{
    FirebaseFirestore.instance.collection('users').doc(widget.currentUser.id).update({'about':_aboutController.text,'profilepic':_currentProfilePic});

  }

  Future<File?> _getImageFromSource(ImagePicker picker, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String> _showImagePickerDialog(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(await _getImageFromSource(picker, ImageSource.gallery));
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop(await _getImageFromSource(picker, ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      _isUploadingFile=true;
    });
    return _handlerProfilePicUpload(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20.0),
              _isUploadingFile?Center(child: CircularProgressIndicator(),):GestureDetector(
                onTap: ()async{
                  final imageUrl = await _showImagePickerDialog(context);
                  setState(() {
                    _currentProfilePic=imageUrl;
                    _isUploadingFile=false;
                  });             
                },
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                  backgroundImage:
                      NetworkImage(_currentProfilePic), // Placeholder image
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _aboutController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'About Me',
                  contentPadding :EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Curved corners
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async{
                  await _handlerEditProfile();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Capsule shape
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10)),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
