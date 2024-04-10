import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OtherProfile extends StatefulWidget {
  final userId;
  const OtherProfile({super.key, required this.userId});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  User currentUser = User(
    id: 'loading',
    batch: '',
    username: "",
    name: "loading...",
    about: "",
    profilepic:
        'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
    branch: '',
    email: '',
  );

  Future<void> fetchUser() async {
    final data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get();
    

    final jsonObject = data.data() as Map<String, dynamic>;
    print(jsonObject);
    final userEmail = jsonObject.containsKey('email')?jsonObject['email']:'';
    final profilepic = jsonObject.containsKey('profilepic')?jsonObject['profilepic']:'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';
    final batch = jsonObject.containsKey('batch')?jsonObject['batch']:'';
    final name = jsonObject.containsKey('fullName')?jsonObject['fullName']:'';
    final branch = jsonObject.containsKey('branch')?jsonObject['branch']:'';
    final instituteId = jsonObject.containsKey('instituteId')?jsonObject['instituteId']:'';
    final about = jsonObject.containsKey('about')?jsonObject['about']:'';
    setState(() {
      User newUser = User(
        id: widget.userId,
        email: userEmail,
        profilepic: profilepic,
        batch: batch,
        name: name,
        branch: branch,
        instituteId: instituteId,
        about: about
      );

      currentUser = newUser;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              child: SingleChildScrollView(
                child: Container(
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
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            '@${currentUser.instituteId}',
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
                                'Batch ${currentUser.batch} ${currentUser.branch!=''?'-':''} ${currentUser.branch!=''?currentUser.branch:''}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExperienceSection(currentUser: currentUser,),
                    SizedBox(height: 10),
                    EducationSection(currentUser: currentUser,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceSection extends StatefulWidget {
  final User currentUser;
  ExperienceSection({required this.currentUser});
  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  @override
  Widget build(BuildContext context) {
    User currentUser = widget.currentUser;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light shade of grey
        borderRadius: BorderRadius.circular(20), // Adjust the value as needed
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Experience list
          // TODO :: STREAMBUILDER HERE
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('experience')
                .where('user_id', isEqualTo: currentUser.id)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('Nothing Here');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentListItem = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          title: Text('${currentListItem['organization_name']} - ${currentListItem['position']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'From : ${currentListItem['from_date']} - To : ${currentListItem['to_date']}'),
                              SizedBox(height: 4),
                              currentListItem['desscription'] != ''
                                  ? Text(
                                      currentListItem['desscription'],
                                      style: TextStyle(fontSize: 12),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExperienceForm extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String description;
  final bool isNew;
  final String experienceId;
  final bool isCurrent;
  final String organization;
  final bool isExperience;
  final String position;
  const ExperienceForm(
      {super.key,
      required this.description,
      required this.fromDate,
      required this.toDate,
      required this.isNew,
      required this.experienceId,
      required this.isCurrent,
      required this.organization,
      required this.isExperience,
      required this.position});

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final GlobalKey<FormState> _experienceFormKey = GlobalKey<FormState>();
  TextEditingController _fromDateController = TextEditingController(text: '');
  TextEditingController _toDateController = TextEditingController(text: '');
  TextEditingController _descriptionController =
      TextEditingController(text: '');
  TextEditingController _organizationController =
      TextEditingController(text: '');
  TextEditingController _errorController = TextEditingController(text: '');
  TextEditingController _positionController = TextEditingController(text: '');

  bool _isCurrent = false;
  bool _isLoading = false;

  late DateTime _selectedStartDate;
  // late DateTime _selectedStartDate;

  Future<void> _validateAndSubmitData(userId, requestType) async {
    if (requestType != 'delete') {
      if (_fromDateController.text == '' ||
          _toDateController.text == '' ||
          _organizationController.text == '' ||
          _positionController.text == '') {
        setState(() {
          _errorController.text =
              'Please provide from date, to date, organization and position, are mandatory';
        });

        return;
      } else {
        setState(() {
          _errorController.text = '';
        });
      }
    }

    final dataObject = {
      'from_date': _fromDateController.text,
      'to_date': _toDateController.text,
      'organization_name': _organizationController.text,
      'desscription': _descriptionController.text,
      'user_id': userId,
      'current_org': _isCurrent,
      'created_at': DateTime.now(),
      'position': _positionController.text
    };

    final collectionName = widget.isExperience ? 'experience' : 'education';

    if (requestType == 'delete') {
      if (widget.experienceId == 'new_experience' ||
          widget.experienceId == 'new') {
        setState(() {
          _errorController.text = 'Something went wrong, please retry again';
        });
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(widget.experienceId)
            .delete();
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      if (!widget.isNew) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(widget.experienceId)
            .update(dataObject);
      } else {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .add(dataObject);
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      _fromDateController.text = widget.fromDate;
      _toDateController.text = widget.toDate;
      _descriptionController.text = widget.description;
      _organizationController.text = widget.organization;
      _positionController.text = widget.position;
      setState(() {
        _isCurrent = widget.isCurrent;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _descriptionController.dispose();
    _organizationController.dispose();
    _errorController.dispose();
    _positionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User currentUser =
        Provider.of<CurrentUser>(context, listen: true).currentUser;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * .9,
        width: MediaQuery.of(context).size.width * 0.95,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${widget.isNew ? 'Add ${widget.isExperience ? 'Experience' : 'Education'}' : 'Edit ${widget.isExperience ? 'Experience' : 'Education'}'}',
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _experienceFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _errorController.text,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Position',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: _positionController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Position',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Curved corners
                                ),
                              ),
                              validator: (value) {
                                if (_positionController.text != '') {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Organization Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: _organizationController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Organization Name',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Curved corners
                                ),
                              ),
                              validator: (value) {
                                if (_organizationController.text != '') {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'From Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: _fromDateController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'From Date',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Curved corners
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                print('------on top event------');
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _selectedStartDate = pickedDate;
                                    _fromDateController.text =
                                        '${DateFormat('MMMM yyyy').format(pickedDate)}';
                                  });
                                }
                              },
                              validator: (value) {
                                if (_fromDateController.text != null) {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'To Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: _toDateController,
                              enabled: !_isCurrent,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'To Date',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Curved corners
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    _selectedStartDate = pickedDate;
                                    _toDateController.text =
                                        '${DateFormat('MMMM yyyy').format(pickedDate)}';
                                  });
                                }
                              },
                              validator: (value) {
                                if (!_isCurrent &&
                                    _toDateController.text != null) {
                                  return 'Please select start date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isCurrent,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCurrent = val!;
                                    });
                                  },
                                ),
                                Text('Current Job')
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              maxLines: 4,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Description',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Curved corners
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                !widget.isNew
                                    ? TextButton.icon(
                                        onPressed: () {
                                          _validateAndSubmitData(
                                              currentUser.id, 'delete');
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        style: ButtonStyle(),
                                      )
                                    : SizedBox(),
                                TextButton.icon(
                                  onPressed: () {
                                    _validateAndSubmitData(
                                        currentUser.id, 'add_or_update');
                                  },
                                  icon: Icon(
                                    widget.isNew ? Icons.add : Icons.edit,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    '${widget.isNew ? 'Add' : 'Edit'}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class EducationSection extends StatelessWidget {
  final currentUser;
  EducationSection({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light shade of grey
        borderRadius: BorderRadius.circular(20), // Adjust the value as needed
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Education',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Open edit education modal
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ExperienceForm(
                        description: '',
                        fromDate: '',
                        toDate: '',
                        isNew: true,
                        experienceId: 'new',
                        isCurrent: false,
                        organization: '',
                        isExperience: false,
                        position: '',
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          // Education list
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('education')
                .where('user_id', isEqualTo: currentUser.id)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('Nothing here');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentListItem = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          title: Text('${currentListItem['organization_name']} - ${currentListItem['position']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'From : ${currentListItem['from_date']} - To : ${currentListItem['to_date']}'),
                              SizedBox(height: 4),
                              currentListItem['desscription'] != ''
                                  ? Text(
                                      currentListItem['desscription'],
                                      style: TextStyle(fontSize: 12),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ExperienceForm(
                                    description:
                                        currentListItem['desscription'],
                                    fromDate: currentListItem['from_date'],
                                    toDate: currentListItem['to_date'],
                                    isNew: false,
                                    experienceId: currentListItem.id,
                                    isCurrent: currentListItem['current_org'],
                                    organization:
                                        currentListItem['organization_name'],
                                    isExperience: false,
                                    position: currentListItem['position'],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
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
  TextEditingController _batchController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  List<int> _years = List.generate(20, (index) => DateTime.now().year - index);
  List<int> _yearsFuture =
      List.generate(4, (index) => DateTime.now().year + index);
  List<int> combinedList = [];

  String _currentProfilePic =
      'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=';
  var _isUploadingFile = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutController = TextEditingController(text: widget.currentUser.about);
    _batchController.text = widget.currentUser.batch;
    _branchController.text = widget.currentUser.branch;

    print(widget.currentUser.branch);
    print(widget.currentUser.batch);
    combinedList = _years + _yearsFuture;
    setState(() {
      _currentProfilePic = widget.currentUser.profilepic;
    });
  }

  Future<String> _handlerProfilePicUpload(File file) async {
    var rng = Random();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/${widget.currentUser.id}-${rng.nextInt(999999)}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _handlerEditProfile() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.currentUser.id)
        .update({
      'about': _aboutController.text,
      'profilepic': _currentProfilePic,
      'batch': _batchController.text,
      'branch': _branchController.text
    });

    Provider.of<CurrentUser>(context, listen: false).updateUserData(
        _aboutController.text,
        _currentProfilePic,
        _batchController.text,
        _branchController.text);
  }

  Future<File?> _getImageFromSource(
      ImagePicker picker, ImageSource source) async {
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
                  Navigator.of(context).pop(
                      await _getImageFromSource(picker, ImageSource.gallery));
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop(
                      await _getImageFromSource(picker, ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      _isUploadingFile = true;
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
              _isUploadingFile
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GestureDetector(
                      onTap: () async {
                        final imageUrl = await _showImagePickerDialog(context);
                        setState(() {
                          _currentProfilePic = imageUrl;
                          _isUploadingFile = false;
                        });
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.3,
                        backgroundImage: NetworkImage(
                            _currentProfilePic), // Placeholder image
                      ),
                    ),
              SizedBox(height: 20.0),
              TextField(
                controller: _aboutController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'About Me',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Curved corners
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _batchController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Batch',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Curved corners
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _branchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Branch',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Curved corners
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
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
