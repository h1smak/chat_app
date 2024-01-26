import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../model/user.dart';
import '../screens/chat_screen.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(userId: widget.user.uid))),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(widget.user.image),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor: widget.user.isOnline
                      ? Colors.green
                      : Colors.grey,
                  radius: 5,
                ),
              ),
            ],
          ),
          title: Text(
            widget.user.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Last Active : ${timeago.format(widget.user.lastActive)}',
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
