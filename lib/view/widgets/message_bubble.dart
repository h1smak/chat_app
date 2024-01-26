import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final bool isImage;
  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? mainColor : Color.fromARGB(255, 209, 208, 208),
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
          ),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isImage
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(
                      message.content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
              const SizedBox(height: 5),
              // Text(
              //   timeago.format(message.sentTime),
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        ),
      );
}
