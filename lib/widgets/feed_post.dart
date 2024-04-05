import 'package:alumnet/icons/custom_icons.dart';
import 'package:alumnet/models/feed_post.dart';
import 'package:alumnet/utils.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:alumnet/models/user.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SocialCard extends StatelessWidget {
  final PostItem post;
  const SocialCard({required this.post, super.key});
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<CurrentUser>(context).currentUser;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profilepic),
              ),
              title: Text(user.name),
              subtitle: buildTimeAgoText(post.timeOfCreation),
              trailing: Icon(Icons.more_horiz),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                post.text,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            SizedBox(height: post.links.isNotEmpty ? 10 : 0),
            post.links.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Links:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: post.links.map((link) {
                              return LinkTile(link: link);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: post.attachments.isNotEmpty ? 10 : 0),
            post.attachments.isNotEmpty
                ? GestureDetector(
                    onTap: () => _showAttachmentsModal(context, post.attachments),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: const ListTile(
                        leading: Icon(CustomIcons.doc_text),
                        title: Text('Attachments'),
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: post.images.isNotEmpty ? 10 : 0),
            post.images.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                    ),
                    items: post.images
                        .map((item) => ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(item, fit: BoxFit.cover, width: 1000),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 7, // 70% of the space
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconTextButton(
                          iconData: CustomIcons.thumbsup,
                          text: post.likes.length.toString(),
                          onTap: () {},
                        ),
                        IconTextButton(
                          iconData: Icons.comment,
                          text: post.comments.length.toString(),
                          onTap: () {},
                        ),
                        IconTextButton(
                          iconData: Icons.share,
                          text: post.noOfShares.toString(),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3, // 30% of the space
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showAttachmentsModal(BuildContext context, List<Attachment> attachments) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: attachments.length,
          itemBuilder: (BuildContext context, int index) {
            final attachment = attachments[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(attachment.name),
                onTap: () => _viewPdfFile(context, attachment.downloadUrl),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadAndOpenFile(context, attachment.downloadUrl, attachment.name),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

Future<void> _viewPdfFile(BuildContext context, String url) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PdfView(pdfFile: url)),
  );
}

Future<void> _downloadAndOpenFile(BuildContext context, String url, String name) async {
  const String folderName = "AlumnetDownloads";
  final dir = await getApplicationDocumentsDirectory();
  final folderPath = '${dir.path}/$folderName';
  final folderExists = await Directory(folderPath).exists();

  if (!folderExists) {
    await Directory(folderPath).create(recursive: true);
  }

  final filePath = '$folderPath/$name';

  final fileExists = await File(filePath).exists();
  print(fileExists);
  print(filePath);
  if (!fileExists) {
    final dio = Dio();
    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1 && received == total) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Your file has been downloaded.",
          ),
        );
      }
    });
  }
}

class PdfView extends StatefulWidget {
  final String pdfFile;
  const PdfView({super.key, required this.pdfFile});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SfPdfViewer.network(widget.pdfFile),
    ));
  }
}

class IconTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final onTap;

  const IconTextButton({
    Key? key,
    required this.onTap,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // This will keep the icon and text together.
      children: <Widget>[
        IconButton(
          icon: Icon(iconData),
          onPressed: onTap,
        ),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }
}

class AttachmentTile extends StatelessWidget {
  final String attachment;

  const AttachmentTile({Key? key, required this.attachment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(CustomIcons.doc_text),
            Text(
              'Attachments',
            )
          ],
        ));
  }
}

class LinkTile extends StatelessWidget {
  final PostLink link;

  const LinkTile({required this.link});

  // Function to launch URLs.
  void _launchURL(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context, link.link),
      child: Text(
        link.text,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
