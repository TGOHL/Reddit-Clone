import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'comment.dart';

class Post {
  final String id;
  final String ownerId;
  final String attachmentUrl;
  final String content;
  final DateTime date;
  int likesCount;
  final List<Comment> comments;

  int get commentsCount {
    int count = 0;
    for (var element in comments) {
      count++;
      count += element.replysCount;
    }
    return count;
  }

  Post({
    required this.id,
    required this.ownerId,
    required this.attachmentUrl,
    required this.content,
    required this.date,
    required this.likesCount,
    required this.comments,
  });

  Post copyWith({
    String? id,
    String? ownerId,
    String? attachmentUrl,
    String? content,
    DateTime? date,
    int? likesCount,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      content: content ?? this.content,
      date: date ?? this.date,
      likesCount: likesCount ?? this.likesCount,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'attachmentUrl': attachmentUrl,
      'content': content,
      'date': date.millisecondsSinceEpoch,
      'likesCount': likesCount,
      'comments': comments.map((x) => x.toMap()).toList(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      attachmentUrl: map['attachmentUrl'] as String,
      content: map['content'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      likesCount: map['likesCount'] as int,
      comments: List<Comment>.from(
        (map['comments'] as List<int>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, ownerId: $ownerId, attachmentUrl: $attachmentUrl, content: $content, date: $date, likesCount: $likesCount, comments: $comments)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.attachmentUrl == attachmentUrl &&
        other.content == content &&
        other.date == date &&
        other.likesCount == likesCount &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        attachmentUrl.hashCode ^
        content.hashCode ^
        date.hashCode ^
        likesCount.hashCode ^
        comments.hashCode;
  }
}
