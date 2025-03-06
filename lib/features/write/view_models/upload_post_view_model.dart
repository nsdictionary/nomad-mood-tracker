import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/repos/authentication_repo.dart';
import '../models/post_mode.dart';
import '../repos/posts_repo.dart';

class UploadPostViewModel extends AsyncNotifier<void> {
  late final PostsRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(postsRepo);
  }

  Future<void> savePost(String mood, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final postModel = PostModel(
        id: '',
        mood: mood,
        content: content,
        creator: ref.read(authRepo).user!.uid,
        creatorName: 'Anon',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repository.savePost(postModel);
    });
  }
}

final uploadPostProvider = AsyncNotifierProvider<UploadPostViewModel, void>(
  () => UploadPostViewModel(),
);
