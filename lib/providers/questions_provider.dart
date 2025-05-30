import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class questions_provider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<question_model> _questions = [];
  bool _is_loading = false;
  String? _error;
  String _selected_category = 'すべて';

  List<question_model> get questions => _questions;
  bool get is_loading => _is_loading;
  String? get error => _error;
  String get selected_category => _selected_category;

  List<question_model> get filtered_questions {
    if (_selected_category == 'すべて') {
      return _questions;
    }
    return _questions.where((question) => question.category == _selected_category).toList();
  }

  void set_selected_category(String category) {
    _selected_category = category;
    notifyListeners();
  }

  Future<void> load_questions() async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      final query_snapshot = await _firestore
          .collection('questions')
          .orderBy('created_at', descending: true)
          .get();

      _questions = query_snapshot.docs
          .map((doc) => question_model.from_firestore(doc))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> create_question(question_model question) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('questions').add(question.to_firestore());
      await load_questions(); // リロード
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> like_question(String question_id, String user_id) async {
    try {
      // いいねの重複チェック
      final existing_like = await _firestore
          .collection('likes')
          .where('question_id', isEqualTo: question_id)
          .where('user_id', isEqualTo: user_id)
          .get();

      if (existing_like.docs.isNotEmpty) {
        // いいねを削除
        await existing_like.docs.first.reference.delete();
        
        // 質問のいいね数を減らす
        await _firestore.collection('questions').doc(question_id).update({
          'likes_count': FieldValue.increment(-1),
        });
      } else {
        // いいねを追加
        await _firestore.collection('likes').add({
          'question_id': question_id,
          'user_id': user_id,
          'created_at': DateTime.now(),
        });
        
        // 質問のいいね数を増やす
        await _firestore.collection('questions').doc(question_id).update({
          'likes_count': FieldValue.increment(1),
        });
      }

      await load_questions(); // リロード
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
