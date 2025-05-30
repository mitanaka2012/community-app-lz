import 'package:cloud_firestore/cloud_firestore.dart';

class notification_model {
  final String id;
  final String title;
  final String body;
  final String? image_url;
  final String? link_url;
  final DateTime published_at;
  final DateTime created_at;
  final DateTime updated_at;

  notification_model({
    required this.id,
    required this.title,
    required this.body,
    this.image_url,
    this.link_url,
    required this.published_at,
    required this.created_at,
    required this.updated_at,
  });

  factory notification_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return notification_model(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      image_url: data['image_url'],
      link_url: data['link_url'],
      published_at: data['published_at']?.toDate() ?? DateTime.now(),
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    final Map<String, dynamic> data = {
      'title': title,
      'body': body,
      'published_at': published_at,
      'created_at': created_at,
      'updated_at': updated_at,
    };

    if (image_url != null) data['image_url'] = image_url;
    if (link_url != null) data['link_url'] = link_url;

    return data;
  }

  // 公開済みかどうかを判定するヘルパーメソッド
  bool get is_published => published_at.isBefore(DateTime.now());

  notification_model copy_with({
    String? title,
    String? body,
    String? image_url,
    String? link_url,
    DateTime? published_at,
    DateTime? updated_at,
  }) {
    return notification_model(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      image_url: image_url ?? this.image_url,
      link_url: link_url ?? this.link_url,
      published_at: published_at ?? this.published_at,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }
}
