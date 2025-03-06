import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../write/view_models/posts_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String routeURL = "/home";
  static String routeName = "home";
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() {
    return ref.watch(postsProvider.notifier).refresh();
  }

  Future<void> _onDeletePost(String postId) {
    return ref.read(postsProvider.notifier).deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(postsProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Could not load posts: $error',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          data: (posts) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              displacement: 50,
              edgeOffset: 20,
              color: Theme.of(context).primaryColor,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 116,
                  title: const Text(
                    '🔥MOOD🔥',
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final postData = posts[index];
                      return GestureDetector(
                        onLongPress: () {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: const Text('Delete note'),
                              message:
                                  const Text('Are you sure want to do this?'),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    _onDeletePost(postData.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size20,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size10,
                                  horizontal: Sizes.size10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size20,
                                  ),
                                  color: const Color(0xff74bda9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mood: ${postData.mood}',
                                      style: const TextStyle(
                                        fontSize: Sizes.size14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Gaps.v3,
                                    Text(
                                      postData.content,
                                      style: const TextStyle(
                                        fontSize: Sizes.size14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.v10,
                              Row(
                                children: [
                                  Text(
                                    timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            postData.createdAt)),
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: Sizes.size14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Gaps.v20,
                  ),
                ),
              ),
            );
          },
        );
  }
}
