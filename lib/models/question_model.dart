import 'package:cloud_firestore/cloud_firestore.dart';

class question_model {
  final String id;
  final String user_id;
  final String title;
  final String body;
  final String category;
  final List<String> image_urls;
  final bool is_anonymous;
  final int answers_count;
  final int likes_count;
  final DateTime created_at;
  final DateTime updated_at;
  
  // 不用品譲り合い用フィールド
  final String? item_type; // "あげます" または "ください"
  final List<String>? handover_method;
  final String? status; // "募集中", "取引中", "終了"

  question_model({
    required this.id,
    required this.user_id,
    required this.title,
    required this.body,
    required this.category,
    required this.image_urls,
    required this.is_anonymous,
    required this.answers_count,
    required this.likes_count,
    required this.created_at,
    required this.updated_at,
    this.item_type,
    this.handover_method,
    this.status,
  });

  factory question_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return question_model(
      id: doc.id,
      user_id: data['user_id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? '',
      image_urls: List<String>.from(data['image_urls'] ?? []),
      is_anonymous: data['is_anonymous'] ?? false,
      answers_count: data['answers_count'] ?? 0,
      likes_count: data['likes_count'] ?? 0,
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
      item_type: data['item_type'],
      handover_method: data['handover_method'] != null 
          ? List<String>.from(data['handover_method']) 
          : null,
      status: data['status'],
    );
  }

  Map<String, dynamic> to_firestore() {
    final Map<String, dynamic> data = {
      'user_id': user_id,
      'title': title,
      'body': body,
      'category': category,
      'image_urls': image_urls,
      'is_anonymous': is_anonymous,
      'answers_count': answers_count,
      'likes_count': likes_count,
      'created_at': created_at,
      'updated_at': updated_at,
    };

    // 不用品譲り合い用フィールドを追加
    if (item_type != null) data['item_type'] = item_type;
    if (handover_method != null) data['handover_method'] = handover_method;
    if (status != null) data['status'] = status;

    return data;
  }

  bool get is_yuzuriai => category == '不用品譲り合い';

  question_model copy_with({
    String? title,
    String? body,
    String? category,
    List<String>? image_urls,
    bool? is_anonymous,
    int? answers_count,
    int? likes_count,
    DateTime? updated_at,
    String? item_type,
    List<String>? handover_method,
    String? status,
  }) {
    return question_model(
      id: id,
      user_id: user_id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      image_urls: image_urls ?? this.image_urls,
      is_anonymous: is_anonymous ?? this.is_anonymous,
      answers_count: answers_count ?? this.answers_count,
      likes_count: likes_count ?? this.likes_count,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
      item_type: item_type ?? this.item_type,
      handover_method: handover_method ?? this.handover_method,
      status: status ?? this.status,
    );
  }
}
