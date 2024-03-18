import 'package:alumnet/icons/custom_icons.dart';
import 'package:alumnet/models/feed_post.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialCard extends StatelessWidget {
  final bool hello;
  SocialCard({required this.hello});
  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.pexels.com/photos/19877487/pexels-photo-19877487/free-photo-of-sun-through-massive-redwood-trees-in-forest.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
      'https://images.pexels.com/photos/16652251/pexels-photo-16652251/free-photo-of-woman-standing-with-camera-among-flowers.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
      'https://images.pexels.com/photos/20448112/pexels-photo-20448112/free-photo-of-brunette-woman-holding-a-fern-leaf-on-a-field.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    ];

    final List<PostLink> links = [
      PostLink(
        link: 'https://developer.mozilla.org/en-US/',
        text: "MDN Web docs",
      ),
      PostLink(
        link: 'https://pub.dev/packages/url_launcher',
        text: "Flutter Package",
      ),
      PostLink(
        link:
            "https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps",
        text: "StackOverFlow",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/id/1365606637/photo/shot-of-a-young-businesswoman-using-a-digital-tablet-while-at-work.jpg?s=2048x2048&w=is&k=20&c=f_VTk3oZAfP5Ja7O3OQ1SK9WQd99EAh3ZcfUmO7lo64='),
              ),
              title: Text('Jacob Washington'),
              subtitle: Text('20m ago'),
              trailing: Icon(Icons.more_horiz),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '"If you think you are too small to make a difference, try sleeping with a mosquito." ~ Dalai Lama',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Slight greyish color
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
              ),
              padding: EdgeInsets.all(12.0), // Padding inside the container
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
                    spacing: 8.0, // Space between horizontal children
                    runSpacing: 4.0, // Space between lines
                    children: links.map((link) {
                      return LinkTile(link: link);
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Slight greyish color
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: ListTile(
                leading: Icon(CustomIcons.doc_text),
                title: Text('Attachments'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            hello
                ? CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                    ),
                    items: imgList
                        .map((item) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(item,
                                      fit: BoxFit.cover, width: 1000),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                : SizedBox(),
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
                            iconData: CustomIcons.thumbsup, text: '2,245'),
                        IconTextButton(iconData: Icons.comment, text: '45'),
                        IconTextButton(iconData: Icons.share, text: '124'),
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
                        child: IconTextButton(
                            iconData: Icons.bookmark_border, text: ''),
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

class IconTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;

  const IconTextButton({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          MainAxisSize.min, // This will keep the icon and text together.
      children: <Widget>[
        Icon(iconData),
        SizedBox(width: 8.0),
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
