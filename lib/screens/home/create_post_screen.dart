import 'dart:io';
import 'dart:ui';
import 'package:alumnet/models/feed_post.dart';
import 'package:alumnet/models/user.dart';
import 'package:alumnet/services/firebase_storage.dart';
import 'package:alumnet/widgets/content_input_card.dart';
import 'package:alumnet/widgets/select_documents.dart';
import 'package:alumnet/widgets/test_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PostCreationScreen extends StatefulWidget {
  static const routename = "./post_creation";
  const PostCreationScreen({super.key});
  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];
  final List<Map<String, TextEditingController>> _linkControllers = [
    {
      'link': TextEditingController(),
      'text': TextEditingController(),
    }
  ];
  final TextEditingController _contentController = TextEditingController();
  String postContent = '';
  List<File?> documents = [];
  List<String> documentNames = [];
  bool isLoading = false;

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
    final List<XFile> pickedFiles =
        await _picker.pickMultiImage(imageQuality: 20);
    setState(() {
      _images.addAll(pickedFiles);
    });
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

  void _createPost() async {
    // Performing checks

    List<PostLink> postLinks = [];

    if (postContent.isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
              "Content cannot be left empty. You have to save your intended content.",
        ),
      );
      return;
    }

    for (Map<String, TextEditingController> linkController
        in _linkControllers) {
      String placeholderText = linkController['text']!.text;
      String linkText = linkController['link']!.text;

      if (placeholderText.isEmpty && linkText.isEmpty) {
        continue;
      }

      if (placeholderText.isEmpty || linkText.isEmpty) {
        int index = _linkControllers.indexOf(linkController) + 1;
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message:
                "Fill both placeholder text and link for Link number $index",
          ),
        );
        return;
      }

      postLinks.add(PostLink(link: linkText, text: placeholderText));
    }

    setState(() {
      isLoading = true;
    });

    // upload the images
    List<String> imageUrls = [];

    try {
      for (XFile image in _images) {
        File imagefile = File(image.path);
        String fileName = imagefile.path.split('/').last;
        final imageRef = fileName;

        String downloadUrl =
            await FileUpload().imageupload(imagefile, imageRef);
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Image Upload Failed for this Post",
        ),
      );

      return;
    }

    List<String> documentUrls = [];

    try {
      for (File? document in documents) {
        String downloadUrl = await FileUpload().pdfupload(document as File);
        documentUrls.add(downloadUrl);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Document Upload Failed for this Post",
        ),
      );

      return;
    }

    if (imageUrls.length != _images.length ||
        documentUrls.length != documents.length) {
      setState(() {
        isLoading = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Something went wrong in uploading those files",
        ),
      );
      return;
    }

    User user = User.fromDummyData();
    PostItem post = PostItem(
        userId: user.id,
        timeOfCreation: DateTime.now().toUtc(),
        text: postContent);

    for (String documentUrl in documentUrls) {
      int index = documentUrls.indexOf(documentUrl);
      Attachment attachment =
          Attachment(name: documentNames[index], downloadUrl: documentUrl);
      post.attachments.add(attachment);
    }

    post.images = imageUrls;
    post.links = postLinks;

    await Provider.of<PostList>(context, listen: false).createPostItem(post);
    Navigator.of(context).pop(post);
  }

  void liftPostContent(String content) {
    postContent = content.isNotEmpty ? content : '';
  }

  void liftSelectedDocuments(
      List<File?> selecteddocuments, List<String> selectedDocumentNames) {
    documents = selecteddocuments;
    documentNames = selectedDocumentNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            // This padding is no longer necessary at this level since you'll want the AppBar to be covered as well.
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                AppBar(
                  title: Text('Create Post'),
                  actions: [
                    IconButton.filledTonal(
                      onPressed: () {
                        _createPost();
                      },
                      icon: const Icon(Icons.check),
                      color: Colors.green,
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextInputCard(
                            getContent: liftPostContent,
                          ),
                          _buildImageUploadCard(),
                          _buildLinkInputCard(),
                          DocumentPicker(
                            getSelectedDocuments: liftSelectedDocuments,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
        ],
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
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
