import 'package:cloud_firestore/cloud_firestore.dart';

class comment_model {
  final String id;
  final String user_id;
  final String? parent_post_id; // はっけんへのコメントの場合
  final String? parent_question_id; // しつもんへの回答の場合
  final String body;
  final DateTime created_at;
  final DateTime updated_at;

  comment_model({
    required this.id,
    required this.user_id,
    this.parent_post_id,
    this.parent_question_id,
    required this.body,
    required this.created_at,
    required this.updated_at,
  });

  factory comment_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return comment_model(
      id: doc.id,
      user_id: data['user_id'] ?? '',
      parent_post_id: data['parent_post_id'],
      parent_question_id: data['parent_question_id'],
      body: data['body'] ?? '',
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    final Map<String, dynamic> data = {
      'user_id': user_id,
      'body': body,
      'created_at': created_at,
      'updated_at': updated_at,
    };

    if (parent_post_id != null) data['parent_post_id'] = parent_post_id;
    if (parent_question_id != null) data['parent_question_id'] = parent_question_id;

    return data;
  }

  comment_model copy_with({
    String? body,
    DateTime? updated_at,
  }) {
    return comment_model(
      id: id,
      user_id: user_id,
      parent_post_id: parent_post_id,
      parent_question_id: parent_question_id,
      body: body ?? this.body,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }
}
