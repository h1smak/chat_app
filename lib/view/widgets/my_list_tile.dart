import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    this.image,
    this.title,
    this.subtitle,
    this.date,
    this.count,
    this.icon,
    this.onTap,
    this.onImageTap,
    required this.border,
  });

  final image;
  final title;
  final subtitle;
  final date;
  final count;
  final icon;
  final onTap;
  final onImageTap;
  final border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  image != null
                      ? GestureDetector(
                          onTap: () => onImageTap(),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.red,
                            child: CircleAvatar(
                              radius: border ? 26 : 30,
                              backgroundImage: NetworkImage(
                                image,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title != null
                            ? Text(
                                title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : Container(),
                        subtitle != null
                            ? Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    date != null
                        ? Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    count != null
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              count,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                icon != null
                    ? Icon(
                        icon,
                        color: Colors.grey.shade400,
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
