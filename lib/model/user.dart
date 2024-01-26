class UserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final String status;
  final DateTime lastActive;
  final bool isOnline;
  final List<dynamic> stories;
  final bool story;

  UserModel({
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    required this.status,
    this.isOnline = false,
    this.story = false,
    required this.stories,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        uid: json['uid'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
        story: json['story'],
        stories: json['stories'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'image': image,
        'email': email,
        'isOnline': isOnline,
        'lastActive': lastActive,
        'story' : story,
        'stories' : stories,
        'status' : status,
      };
}
