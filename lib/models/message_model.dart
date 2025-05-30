import 'package:cloud_firestore/cloud_firestore.dart';

class message_model {
  final String id;
  final String sender_id;
  final String message_text;
  final DateTime sent_at;

  message_model({
    required this.id,
    required this.sender_id,
    required this.message_text,
    required this.sent_at,
  });

  factory message_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return message_model(
      id: doc.id,
      sender_id: data['sender_id'] ?? '',
      message_text: data['message_text'] ?? '',
      sent_at: data['sent_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    return {
      'sender_id': sender_id,
      'message_text': message_text,
      'sent_at': sent_at,
    };
  }

  // 自分が送信したメッセージかどうかを判定するヘルパーメソッド
  bool is_sent_by_me(String current_user_id) {
    return sender_id == current_user_id;
  }
}
