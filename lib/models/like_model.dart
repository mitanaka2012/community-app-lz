import 'package:cloud_firestore/cloud_firestore.dart';

class like_model {
  final String id;
  final String user_id;
  final String? post_id; // はっけん投稿の場合
  final String? question_id; // しつもん投稿の場合
  final DateTime created_at;

  like_model({
    required this.id,
    required this.user_id,
    this.post_id,
    this.question_id,
    required this.created_at,
  });

  factory like_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return like_model(
      id: doc.id,
      user_id: data['user_id'] ?? '',
      post_id: data['post_id'],
      question_id: data['question_id'],
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    final Map<String, dynamic> data = {
      'user_id': user_id,
      'created_at': created_at,
    };

    if (post_id != null) data['post_id'] = post_id;
    if (question_id != null) data['question_id'] = question_id;

    return data;
  }

  // いいねのタイプを判定するヘルパーメソッド
  bool get is_post_like => post_id != null;
  bool get is_question_like => question_id != null;

  // いいねのターゲットIDを取得するヘルパーメソッド
  String get target_id => post_id ?? question_id ?? '';
}
