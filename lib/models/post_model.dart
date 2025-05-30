import 'package:cloud_firestore/cloud_firestore.dart';

class post_model {
  final String id;
  final String user_id;
  final String body;
  final String category;
  final List<String> image_urls;
  final int likes_count;
  final int comments_count;
  final DateTime created_at;
  final DateTime updated_at;

  post_model({
    required this.id,
    required this.user_id,
    required this.body,
    required this.category,
    required this.image_urls,
    required this.likes_count,
    required this.comments_count,
    required this.created_at,
    required this.updated_at,
  });

  factory post_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return post_model(
      id: doc.id,
      user_id: data['user_id'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? '',
      image_urls: List<String>.from(data['image_urls'] ?? []),
      likes_count: data['likes_count'] ?? 0,
      comments_count: data['comments_count'] ?? 0,
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    return {
      'user_id': user_id,
      'body': body,
      'category': category,
      'image_urls': image_urls,
      'likes_count': likes_count,
      'comments_count': comments_count,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  post_model copy_with({
    String? body,
    String? category,
    List<String>? image_urls,
    int? likes_count,
    int? comments_count,
    DateTime? updated_at,
  }) {
    return post_model(
      id: id,
      user_id: user_id,
      body: body ?? this.body,
      category: category ?? this.category,
      image_urls: image_urls ?? this.image_urls,
      likes_count: likes_count ?? this.likes_count,
      comments_count: comments_count ?? this.comments_count,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }
}
