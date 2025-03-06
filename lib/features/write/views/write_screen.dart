import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../../authentication/views/widgets/form_button.dart';
import '../view_models/upload_post_view_model.dart';

class WriteScreen extends ConsumerStatefulWidget {
  static String routeURL = "/write";
  static String routeName = "write";
  const WriteScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<WriteScreen> {
  late final TextEditingController _editingController;
  String _postContent = '';
  int _selectedMoodIdx = 0;

  final _moodList = [
    '😀',
    '😍',
    '😋',
    '😭',
    '😨',
    '🥶',
    '💀',
    '🤢',
  ];

  Future<void> _uploadPost() async {
    await ref
        .read(uploadPostProvider.notifier)
        .savePost(_moodList[_selectedMoodIdx], _postContent);

    if (!mounted) return;

    print(111111111111);
    FocusScope.of(context).unfocus();
    _editingController.clear();
    setState(() {
      _postContent = '';
    });

    context.go('/');
  }

  @override
  void initState() {
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v44,
                const Center(
                  child: Text(
                    '🔥MOOD🔥',
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gaps.v96,
                const Text(
                  'How do you feel?',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v16,
                SizedBox(
                  height: Sizes.size96,
                  child: TextField(
                    controller: _editingController,
                    onChanged: (value) {
                      setState(() {
                        _postContent = value;
                        print(_postContent);
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Sizes.size12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Sizes.size12,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: Sizes.size10,
                      ),
                      hintText: 'write it down here!',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Gaps.v16,
                const Text(
                  'What\'s your mood?',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var (index, mood) in _moodList.indexed)
                      _emojiContainer(mood, index),
                  ],
                ),
                Gaps.v20,
                FormButton(
                  onTapFunc: (context) async {
                    if (_postContent.isNotEmpty) {
                      await _uploadPost();
                    }
                  },
                  disabled: _postContent.isEmpty,
                  text: 'Post',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _emojiContainer(String emoji, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMoodIdx = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(
          Sizes.size10,
        ),
        decoration: BoxDecoration(
            color: _selectedMoodIdx == index
                ? Theme.of(context).primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(
              Sizes.size12,
            ),
            border: Border.all(
              color: Colors.black,
              width: 2,
            )),
        child: Text(emoji),
      ),
    );
  }
}
