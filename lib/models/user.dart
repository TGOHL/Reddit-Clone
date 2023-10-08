import 'dart:convert';

class User {
  final String id;
  final String name;
  final String? subname;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    this.subname,
    required this.imageUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? subname,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      subname: subname ?? this.subname,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'subname': subname,
      'imageUrl': imageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      subname: map['subname'] != null ? map['subname'] as String : null,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, subname: $subname, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.subname == subname &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      subname.hashCode ^
      imageUrl.hashCode;
  }
}
