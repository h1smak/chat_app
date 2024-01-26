import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/controllers/camera.dart';
import 'package:firebase_chat_app/firestore_models/story_model.dart';
import 'package:firebase_chat_app/firestore_models/user_data.dart';
import 'package:firebase_chat_app/firestore_models/user_firestore_model.dart';
import 'package:firebase_chat_app/global.dart';
import 'package:firebase_chat_app/view/screens/chat_screen.dart';
import 'package:firebase_chat_app/view/screens/profile_screen.dart';
import 'package:firebase_chat_app/view/screens/story_preview.dart';
import 'package:firebase_chat_app/view/widgets/my_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('People'),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          MyStatus(),
          Stories(),
          PeopleList(),
        ],
      ),
    );
  }
}

Stream<UserData> getFirebaseDataStream(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .where("uid", isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshot.docs[0].data();
      return UserData.fromMap(data);
    } else {
      return UserData(image: '');
    }
  });
}

class MyStatus extends StatelessWidget {
  const MyStatus({Key? key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder<UserData>(
        stream: getFirebaseDataStream(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data available');
          } else {
            UserData user = snapshot.data!;
            List<UserFirestoreModel> sampleUsers = [];
            List<StoryModel> stories = [];
            stories = user.stories.map((img) => StoryModel(img)).toList();
            sampleUsers
                .add(UserFirestoreModel(user.name!, user.image!, stories));

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => user.story
                                ? navigate(
                                    context,
                                    StoryPreview(
                                      users: sampleUsers,
                                      pageIndex: 0,
                                    ))
                                : {},
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue.shade700,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: user.story ? 37 : 40,
                                    backgroundImage: NetworkImage(user.image!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 100,
                                  ),
                                  child: Text(
                                    user.status!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Camera.stories(onUpload: (url) async {
                                updateStories(user.uid, url);
                              }).showModal(context);
                            },
                            icon: const Icon(
                              CupertinoIcons.camera,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                {navigate(context, ProfileScreen())},
                            icon: const Icon(
                              CupertinoIcons.pencil,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class Stories extends StatelessWidget {
  Stories({Key? key});

  List<UserFirestoreModel> sampleUsers = [];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder<List<UserData>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) =>
                    UserData.fromMap(doc.data() as Map<String, dynamic>))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          } else {
            List<UserData?> users = snapshot.data!;
            sampleUsers = users.where((people) => people!.story).map((people) {
                  List<StoryModel> stories =
                      people!.stories.map((img) => StoryModel(img)).toList();
                  return UserFirestoreModel(
                      people.name!, people.image!, stories);
                }).toList() ??
                [];

            return sampleUsers.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Recent Updates',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: users
                                  .where((UserData? element) => element!.story)
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                (entry) {
                                  int index = entry.key;
                                  UserData? el = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => navigate(
                                            context,
                                            StoryPreview(
                                              users: sampleUsers,
                                              pageIndex: index,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.blue,
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: el!.story ? 37 : 40,
                                                  backgroundImage:
                                                      NetworkImage(el.image!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          el.name!,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  )
                : Container();
          }
        },
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  const PeopleList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                  (doc) => UserData.fromMap(doc.data() as Map<String, dynamic>))
              .toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(child: Container());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        } else {
          List<UserData?> users = snapshot.data!;
          return SliverList(
            delegate: SliverChildListDelegate(
              users
                  .map(
                    (e) => MyListTile(
                      icon: Icons.chevron_right,
                      image: e!.image,
                      key: UniqueKey(),
                      title: '${e.name}',
                      subtitle: e.status,
                      border: false,
                      onTap: () =>
                          navigate(context, ChatScreen(userId: e.uid!)),
                      onImageTap: () => {},
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
    );
  }
}
