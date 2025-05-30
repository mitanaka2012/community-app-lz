import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class posts_provider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<post_model> _posts = [];
  bool _is_loading = false;
  String? _error;
  String _selected_category = 'すべて';

  List<post_model> get posts => _posts;
  bool get is_loading => _is_loading;
  String? get error => _error;
  String get selected_category => _selected_category;

  List<post_model> get filtered_posts {
    if (_selected_category == 'すべて') {
      return _posts;
    }
    return _posts.where((post) => post.category == _selected_category).toList();
  }

  void set_selected_category(String category) {
    _selected_category = category;
    notifyListeners();
  }

  Future<void> load_posts() async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      final query_snapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .get();

      _posts = query_snapshot.docs
          .map((doc) => post_model.from_firestore(doc))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> create_post(post_model post) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('posts').add(post.to_firestore());
      await load_posts(); // リロード
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> like_post(String post_id, String user_id) async {
    try {
      // いいねの重複チェック
      final existing_like = await _firestore
          .collection('likes')
          .where('post_id', isEqualTo: post_id)
          .where('user_id', isEqualTo: user_id)
          .get();

      if (existing_like.docs.isNotEmpty) {
        // いいねを削除
        await existing_like.docs.first.reference.delete();
        
        // 投稿のいいね数を減らす
        await _firestore.collection('posts').doc(post_id).update({
          'likes_count': FieldValue.increment(-1),
        });
      } else {
        // いいねを追加
        await _firestore.collection('likes').add({
          'post_id': post_id,
          'user_id': user_id,
          'created_at': DateTime.now(),
        });
        
        // 投稿のいいね数を増やす
        await _firestore.collection('posts').doc(post_id).update({
          'likes_count': FieldValue.increment(1),
        });
      }

      await load_posts(); // リロード
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void clear_error() {
    _error = null;
    notifyListeners();
  }
}
