import 'package:firebase_chat_app/firestore_models/story_model.dart';

class UserFirestoreModel {
  final String userName;
  final String imageUrl;
  final List<StoryModel> stories;

  UserFirestoreModel(
    this.userName,
    this.imageUrl,
    this.stories,
  );
}
