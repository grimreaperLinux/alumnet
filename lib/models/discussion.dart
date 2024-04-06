import "package:alumnet/models/user.dart";

final sampleUser = User.fromdummyData();

class Discussion {
  final User postedBy;
  final String postedAt;
  final String headline;
  final DiscussionContent content;
  final int activityCount;

  Discussion({
    required this.postedBy,
    required this.postedAt,
    required this.headline,
    required this.content,
    required this.activityCount,
  });
}

class DiscussionContent {
  final List<DiscussionElement> elements;

  DiscussionContent({required this.elements});
}

class DiscussionElement {
  final ContentType type;
  final dynamic value;

  DiscussionElement({required this.type, required this.value});
}

enum ContentType { text, image, link }

// Sample content elements
List<DiscussionElement> contentElements = [
  DiscussionElement(
    type: ContentType.text,
    value: "What do you think about the future of AI?",
  ),
  DiscussionElement(
    type: ContentType.link,
    value: Uri.parse("https://example.com/ai-future-article"),
  ),
  DiscussionElement(
    type: ContentType.image,
    value: Uri.parse(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAT-xYms93u2xSGYRqxRToPIioQBjd9FsD75ZZ4-JcnQ&s"),
  ),
];

// Create a DiscussionContent instance
DiscussionContent discussionContent =
    DiscussionContent(elements: contentElements);

// Sample discussion instance
Discussion sampleDiscussion = Discussion(
  postedBy: sampleUser,
  postedAt: DateTime.now()
      .toString(), // You may need to format the date according to your requirement
  headline: "NFTs in Web3.0 era: Digital Ownerships and tokenisation of assets",
  content: discussionContent,
  activityCount: 120,
);
