import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

import '../constants/assets.dart';
import '../constants/enums.dart';
import '../models/comment.dart';
import '../services/database.dart';
import 'arrow_group.dart';
import 'menu_button.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  final Function(String id) onCommentDeleted;
  const CommentTile(
      {super.key,
      required this.comment,
      this.isReply = false,
      required this.onCommentDeleted});

  @override
  Widget build(BuildContext context) {
    final user = DatabaseService().getUserById(comment.ownerId);
    var title = Runes(
      '${user.name} \u00b7 ${format(comment.date, locale: 'en_short')}',
    );
    return Container(
      margin: EdgeInsets.only(bottom: !isReply ? 6 : 0),
      decoration: BoxDecoration(
        color: !isReply ? Colors.white12 : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: !isReply
                  ? null
                  : const BorderDirectional(
                      start: BorderSide(width: 1, color: Colors.white24),
                    ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white12,
                    backgroundImage: AssetImage(ASSET_PROFILE_2_IMAGE),
                  ),
                  title: Text(
                    String.fromCharCodes(title),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: user.subname != null
                      ? Text(
                          user.subname!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : null,
                ),
                Text(comment.content),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF1B1B1B),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const MenuButton(
                                    label: 'Share',
                                    iconData: Icons.file_upload_outlined,
                                  ),
                                  const MenuButton(
                                    label: 'Save',
                                    iconData: Icons.bookmark_border,
                                  ),
                                  const MenuButton(
                                    label: 'Stop reply notification',
                                    iconData: Icons.notifications,
                                  ),
                                  const MenuButton(
                                    label: 'Copy text',
                                    iconData: Icons.copy,
                                  ),
                                  const MenuButton(
                                    label: 'Edit',
                                    iconData: Icons.edit_outlined,
                                  ),
                                  MenuButton(
                                    label: 'Delete',
                                    iconData: Icons.delete_outline,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog.adaptive(
                                            backgroundColor:
                                                const Color(0xFF0E0E0E),
                                            title: const Text(
                                              "Are you sure?",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: const Text(
                                                "You cannot restore comments that have been deleted."),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.white24,
                                                ),
                                                child: const Text(
                                                  "CANCEL",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  onCommentDeleted(comment.id);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white12),
                                        child: const Text(
                                          "Close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_horiz, size: 22),
                    ),
                    if (isReply)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.reply, size: 24),
                      ),
                    if (!isReply)
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.reply,
                          size: 24,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Reply",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ArrowGroup(
                      axis: ArrowGoupAxis.HORIZONTAL,
                      likesCount: comment.likesCount,
                      onChange: (delta) {
                        comment.likesCount += delta;
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          if (comment.replys.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Column(
                children: comment.replys
                    .map(
                      (e) => CommentTile(
                        comment: e,
                        isReply: true,
                        onCommentDeleted: (id) {
                          onCommentDeleted(id);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
