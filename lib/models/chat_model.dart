import 'package:cloud_firestore/cloud_firestore.dart';

class chat_model {
  final String id;
  final List<String> user_ids;
  final String last_message_text;
  final DateTime last_message_sent_at;
  final DateTime created_at;
  final DateTime updated_at;

  chat_model({
    required this.id,
    required this.user_ids,
    required this.last_message_text,
    required this.last_message_sent_at,
    required this.created_at,
    required this.updated_at,
  });

  factory chat_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return chat_model(
      id: doc.id,
      user_ids: List<String>.from(data['user_ids'] ?? []),
      last_message_text: data['last_message_text'] ?? '',
      last_message_sent_at: data['last_message_sent_at']?.toDate() ?? DateTime.now(),
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    return {
      'user_ids': user_ids,
      'last_message_text': last_message_text,
      'last_message_sent_at': last_message_sent_at,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  // チャットIDを生成するヘルパーメソッド
  static String generate_chat_id(String user_id1, String user_id2) {
    final sorted_ids = [user_id1, user_id2]..sort();
    return '${sorted_ids[0]}_${sorted_ids[1]}';
  }

  // 相手のユーザーIDを取得するヘルパーメソッド
  String get_other_user_id(String current_user_id) {
    return user_ids.firstWhere((id) => id != current_user_id);
  }

  chat_model copy_with({
    String? last_message_text,
    DateTime? last_message_sent_at,
    DateTime? updated_at,
  }) {
    return chat_model(
      id: id,
      user_ids: user_ids,
      last_message_text: last_message_text ?? this.last_message_text,
      last_message_sent_at: last_message_sent_at ?? this.last_message_sent_at,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }
}
