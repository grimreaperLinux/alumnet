import 'dart:io';
import 'package:alumnet/widgets/content_input_card.dart';
import 'package:alumnet/widgets/select_documents.dart';
import 'package:alumnet/widgets/test_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostCreationScreen extends StatefulWidget {
  static const routename = "./post_creation";
  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  final List<Map<String, TextEditingController>> _linkControllers = [
    {
      'link': TextEditingController(),
      'text': TextEditingController(),
    }
  ];
  final TextEditingController _contentController = TextEditingController();
  bool textFieldStatus = false;

  @override
  void dispose() {
    for (var controllerPair in _linkControllers) {
      controllerPair['link']!.dispose();
      controllerPair['text']!.dispose();
    }
    _contentController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _addLinkField() {
    setState(() {
      _linkControllers.add({
        'link': TextEditingController(),
        'text': TextEditingController(),
      });
    });
  }

  void _removeLinkField(int index) {
    setState(() {
      _linkControllers[index]['link']!.dispose();
      _linkControllers[index]['text']!.dispose();
      _linkControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextInputCard(),
              _buildImageUploadCard(),
              _buildLinkInputCard(),
              DocumentPicker()
            ],
          ),
        ),
      ),
    );
  }

  Card _buildImageUploadCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 15),
        child: Column(
          children: [
            _images.isNotEmpty
                ? CarouselSlider(
                    items: _images.map((item) {
                      int index = _images.indexOf(item);
                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(File(item.path),
                                fit: BoxFit.cover, width: 1000),
                          ),
                          Positioned(
                            right: -10, // Adjust the position accordingly
                            top: -10, // Adjust the position accordingly
                            child: IconButton(
                              iconSize: 30, // Set an appropriate size
                              icon: CircleAvatar(
                                radius: 10, // Set an appropriate radius
                                backgroundColor: Colors.red[200],
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                    ),
                  )
                : const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No Images Selected',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Material(
              elevation: 5,
              color: const Color(0xff345C67),
              borderRadius: BorderRadius.circular(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () {
                  _pickImage();
                },
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Select Image',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card _buildLinkInputCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 15),
        child: Column(
          children: [
            for (int i = 0; i < _linkControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _linkControllers[i]['link']!,
                      decoration: const TextFieldCustom(
                              hinttext: "Enter Link", labeltext: "Link")
                          .textfieldDecoration(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _linkControllers[i]['text']!,
                      decoration: const TextFieldCustom(
                              hinttext: "Placeholder Text", labeltext: "Text")
                          .textfieldDecoration(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => _removeLinkField(i),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Material(
              elevation: 5,
              color: const Color(0xff345C67),
              borderRadius: BorderRadius.circular(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () {
                  _addLinkField();
                },
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Add Link',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
