import 'package:alumnet/models/discussion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLikeToDiscussion(
      String communityId, String discussionId, String userId) async {
    try {
      await _firestore
          .collection('discussions')
          .doc(communityId)
          .collection('posts')
          .doc(discussionId)
          .update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print('Error adding like to discussion: $e');
      throw e;
    }
  }

  Future<void> removeLikeFromDiscussion(
      String communityId, String discussionId, String userId) async {
    try {
      await _firestore.collection('discussions').doc(discussionId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      print('Error removing like from discussion: $e');
      throw e;
    }
  }

  Future<void> addComment(
      String parentId, Discussion comment, String path) async {
    try {
      await _firestore.collection(path).doc(parentId).update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
      });
    } catch (e) {
      print('Error adding comment to discussion: $e');
      throw e;
    }
  }
}
