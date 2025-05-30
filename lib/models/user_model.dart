import 'package:cloud_firestore/cloud_firestore.dart';

class user_model {
  final String uid;
  final String nickname;
  final String postal_code;
  final bool has_children;
  final bool is_aspiring_parent;
  final bool is_community_contributor;
  final List<String> child_age_ranges;
  final DateTime? due_date;
  final String? self_introduction;
  final String? profile_image_url;
  final List<String> interests;
  final DateTime created_at;
  final DateTime updated_at;

  user_model({
    required this.uid,
    required this.nickname,
    required this.postal_code,
    required this.has_children,
    required this.is_aspiring_parent,
    required this.is_community_contributor,
    required this.child_age_ranges,
    this.due_date,
    this.self_introduction,
    this.profile_image_url,
    required this.interests,
    required this.created_at,
    required this.updated_at,
  });

  factory user_model.from_firestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return user_model(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      postal_code: data['postal_code'] ?? '',
      has_children: data['has_children'] ?? false,
      is_aspiring_parent: data['is_aspiring_parent'] ?? false,
      is_community_contributor: data['is_community_contributor'] ?? false,
      child_age_ranges: List<String>.from(data['child_age_ranges'] ?? []),
      due_date: data['due_date']?.toDate(),
      self_introduction: data['self_introduction'],
      profile_image_url: data['profile_image_url'],
      interests: List<String>.from(data['interests'] ?? []),
      created_at: data['created_at']?.toDate() ?? DateTime.now(),
      updated_at: data['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> to_firestore() {
    return {
      'uid': uid,
      'nickname': nickname,
      'postal_code': postal_code,
      'has_children': has_children,
      'is_aspiring_parent': is_aspiring_parent,
      'is_community_contributor': is_community_contributor,
      'child_age_ranges': child_age_ranges,
      'due_date': due_date,
      'self_introduction': self_introduction,
      'profile_image_url': profile_image_url,
      'interests': interests,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  user_model copy_with({
    String? nickname,
    String? postal_code,
    bool? has_children,
    bool? is_aspiring_parent,
    bool? is_community_contributor,
    List<String>? child_age_ranges,
    DateTime? due_date,
    String? self_introduction,
    String? profile_image_url,
    List<String>? interests,
    DateTime? updated_at,
  }) {
    return user_model(
      uid: uid,
      nickname: nickname ?? this.nickname,
      postal_code: postal_code ?? this.postal_code,
      has_children: has_children ?? this.has_children,
      is_aspiring_parent: is_aspiring_parent ?? this.is_aspiring_parent,
      is_community_contributor: is_community_contributor ?? this.is_community_contributor,
      child_age_ranges: child_age_ranges ?? this.child_age_ranges,
      due_date: due_date ?? this.due_date,
      self_introduction: self_introduction ?? this.self_introduction,
      profile_image_url: profile_image_url ?? this.profile_image_url,
      interests: interests ?? this.interests,
      created_at: created_at,
      updated_at: updated_at ?? DateTime.now(),
    );
  }
}
