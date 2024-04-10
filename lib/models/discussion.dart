import "package:alumnet/models/comment.dart";
import "package:alumnet/models/user.dart";

final sampleUser = User.fromDummyData();

class Discussion {
  final String id;
  final User postedBy;
  final DateTime postedAt;
  final String headline;
  final DiscussionContent? content;
  final String? parentId;
  final List<String> likes;
  final List<Discussion> comments;

  Discussion({
    required this.id,
    required this.postedBy,
    required this.postedAt,
    required this.headline,
    this.content,
    this.parentId,
    List<String>? likes,
    List<Discussion>? comments,
  })  : likes = likes ?? [],
        comments = comments ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postedBy': postedBy.toMap(),
      'postedAt': postedAt.toIso8601String(),
      'headline': headline,
      'content': content?.toMap(),
      'parentId': parentId,
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }

  factory Discussion.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Map is null');
    }
    final String id = map['id'] ?? '';
    final User postedBy = User.fromMap(map['postedBy']);
    final DateTime postedAt = DateTime.parse(map['postedAt']);
    final String headline = map['headline'] ?? '';
    final DiscussionContent content =
        DiscussionContent.fromMap(map['content'] ?? {});
    final List<String> likes = List<String>.from(map['likes'] ?? []);
    final List<Discussion> comments = List<Discussion>.from(
        (map['comments'] ?? [])
            .map((commentMap) => Discussion.fromMap(commentMap)));

    return Discussion(
      id: id,
      postedBy: postedBy,
      postedAt: postedAt,
      headline: headline,
      content: content,
      parentId: map['parentId'],
      likes: likes,
      comments: comments,
    );
  }
}

class DiscussionContent {
  final List<DiscussionElement> elements;

  DiscussionContent({required this.elements});

  Map<String, dynamic> toMap() {
    return {
      'elements': elements.map((element) => element.toMap()).toList(),
    };
  }

  factory DiscussionContent.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Map is null');
    }
    final List<dynamic> elementMaps = map['elements'] ?? [];
    final List<DiscussionElement> elements = elementMaps
        .map((elementMap) => DiscussionElement.fromMap(elementMap))
        .toList();

    return DiscussionContent(elements: elements);
  }
}

class DiscussionElement {
  final ContentType type;
  final dynamic value;

  DiscussionElement({required this.type, required this.value});

  Map<String, dynamic> toMap() {
    print('Serializing DiscussionElement:');
    print('Type: ${type.toString()}');
    print('Value: ${value.toString()}');
    return {
      'type': type.toString(), // Store type as string
      'value': value.toString(), // Store value as string
    };
  }

  factory DiscussionElement.fromMap(Map<String, dynamic> map) {
    final String typeString = map['type'];
    final dynamic value = map['value'];

    print('Deserializing DiscussionElement:');
    print('Type: $typeString');
    print('Value: $value');

    ContentType type;
    switch (typeString) {
      case 'ContentType.text':
        type = ContentType.text;
        break;
      case 'ContentType.image':
        type = ContentType.image;
        break;
      case 'ContentType.link':
        type = ContentType.link;
        break;
      default:
        throw ArgumentError('Invalid type: $typeString');
    }

    return DiscussionElement(type: type, value: value);
  }
}

enum ContentType { text, image, link }

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

DiscussionContent discussionContent =
    DiscussionContent(elements: contentElements);

Discussion sampleDiscussion = Discussion(
  id: "sdasdasdsds",
  postedBy: sampleUser,
  postedAt: DateTime.now(),
  headline: "NFTs in Web3.0 era: Digital Ownerships and tokenisation of assets",
  content: discussionContent,
);
