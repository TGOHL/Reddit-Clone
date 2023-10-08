import 'dart:convert';

import 'package:flutter/foundation.dart';

class Comment {
  final String id;
  final String ownerId;
  final String content;
  int likesCount;
  final DateTime date;
  final List<Comment> replys;

  int get replysCount {
    int count = 0;
    for (var element in replys) {
      count++;
      count += element.replysCount;
    }
    return count;
  }

  Comment({
    required this.id,
    required this.ownerId,
    required this.content,
    required this.likesCount,
    required this.date,
    required this.replys,
  });

  Comment copyWith({
    String? id,
    String? ownerId,
    String? content,
    int? likesCount,
    DateTime? date,
    List<Comment>? replys,
  }) {
    return Comment(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      date: date ?? this.date,
      replys: replys ?? this.replys,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'content': content,
      'likesCount': likesCount,
      'date': date.millisecondsSinceEpoch,
      'replys': replys.map((x) => x.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      content: map['content'] as String,
      likesCount: map['likesCount'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      replys: List<Comment>.from(
        (map['replys'] as List<int>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, ownerId: $ownerId, content: $content, likesCount: $likesCount, date: $date, replys: $replys)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.content == content &&
        other.likesCount == likesCount &&
        other.date == date &&
        listEquals(other.replys, replys);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        content.hashCode ^
        likesCount.hashCode ^
        date.hashCode ^
        replys.hashCode;
  }
}
