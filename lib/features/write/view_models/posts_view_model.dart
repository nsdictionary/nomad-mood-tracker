import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_mode.dart';
import '../repos/posts_repo.dart';

class PostsViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostsRepository _repository;
  List<PostModel> _list = [];

  Future<List<PostModel>> _fetchPosts({
    int? lastItemCreatedAt,
  }) async {
    final result =
        await _repository.fetchPosts(lastItemCreatedAt: lastItemCreatedAt);
    final posts = result.docs.map(
      (doc) => PostModel.fromJson(
        json: doc.data(),
        postId: doc.id,
      ),
    );
    return posts.toList();
  }

  @override
  FutureOr<List<PostModel>> build() async {
    _repository = ref.read(postsRepo);
    _list = await _fetchPosts(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage = await _fetchPosts(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final posts = await _fetchPosts(lastItemCreatedAt: null);
    _list = posts;
    state = AsyncValue.data(posts);
  }

  Future<void> deletePost(String postId) async {
    await _repository.deletePost(postId);
    refresh();
  }
}

final postsProvider = AsyncNotifierProvider<PostsViewModel, List<PostModel>>(
  () => PostsViewModel(),
);
