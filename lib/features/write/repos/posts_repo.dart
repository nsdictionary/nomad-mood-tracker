import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_mode.dart';

class PostsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> savePost(PostModel data) async {
    final result = await _db.collection("posts").add(data.toJson());
    return result.id;
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts({
    int? lastItemCreatedAt,
  }) async {
    final query = _db
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .limit(10);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }
}

final postsRepo = Provider((ref) => PostsRepository());
