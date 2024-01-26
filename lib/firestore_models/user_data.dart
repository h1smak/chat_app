import 'package:firestore_model/firestore_model.dart';

class UserData extends FirestoreModel<UserData> {
 String? uid;
 String? name;
 String? email;
 String? image;
 String? status;
 DateTime? lastActive;
 bool isOnline = true;
 List<dynamic> stories = [];
 bool story = false;

  UserData({this.uid, this.name, this.image});

  UserData.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    stories = map['stories'] != null ? List.from(map['stories']) : [];
    story = map['story'];
    image = map['image'];
    lastActive = map['lastActive'].toDate();
    isOnline = map['isOnline'];
    status = map['status'];
  }

  @override
  ResponseBuilder<UserData> get responseBuilder => (map) => UserData.fromMap(map);

  @override
  Map<String, dynamic> get toMap => {
    'uid' : uid,
    'image' : image,
    'name' : name,
    'email' : email,
    'stories' : stories,
    'story' : story,
    'lastActive' : lastActive,
    'isOnline' : isOnline,
    'status' : status,
  };
}
