import 'package:firebase_chat_app/firestore_models/user_firestore_model.dart';
import 'package:story/story_page_view.dart';

import 'package:flutter/material.dart';

class StoryPreview extends StatefulWidget {
  const StoryPreview({
    Key? key,
    this.pageIndex,
    required this.users,
  }) : super(key: key);

  final pageIndex;
  final List<UserFirestoreModel> users;

  @override
  State<StoryPreview> createState() => _StoryPreviewState(pageIndex, users);
}

class _StoryPreviewState extends State<StoryPreview> {
  final pageIndex;
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  final List<UserFirestoreModel> sampleUsers;

  _StoryPreviewState(this.pageIndex, this.sampleUsers);

  @override
  void initState() {
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
    super.initState();
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StoryPageView(
          itemBuilder: (BuildContext context, int pageIndex, int storyIndex) {
            final user = sampleUsers[pageIndex];
            final story = user.stories[storyIndex];
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Positioned.fill(
                  child: Image.network(
                    story.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 44),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
          storyLength: (int pageIndex) {
            return sampleUsers[pageIndex].stories.length;
          },
          gestureItemBuilder: (BuildContext context, int pageIndex, int storyIndex) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 40,
                //   top: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 32),
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.more_vert,
                //         color: Colors.white,
                //       ),
                //       onPressed: () => _showOptions(context),
                //     ),
                //   ),
                // )
              ],
            );
          },
          pageLength: sampleUsers.length,
          initialStoryIndex: (int pageIndex) {
            return 0;
          },
          initialPage: this.pageIndex,
          onPageLimitReached: () {
            Navigator.of(context).pop();
          },
          indicatorAnimationController: indicatorAnimationController,
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Report'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Mute'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Cancel'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Route<void> _modelBuilder(BuildContext context, Object? arguments) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Options'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Report'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Mute'),
          ),
        ],
      );
    },
  );
}
