import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class auth_service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google_sign_in = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get current_user => _auth.currentUser;

  Stream<User?> get auth_state_changes => _auth.authStateChanges();

  // メールアドレスとパスワードでサインアップ
  Future<UserCredential?> sign_up_with_email_and_password(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handle_auth_exception(e);
    }
  }

  // メールアドレスとパスワードでサインイン
  Future<UserCredential?> sign_in_with_email_and_password(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handle_auth_exception(e);
    }
  }

  // Googleサインイン
  Future<UserCredential?> sign_in_with_google() async {
    try {
      final GoogleSignInAccount? google_user = await _google_sign_in.signIn();
      if (google_user == null) return null;

      final GoogleSignInAuthentication google_auth = 
          await google_user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: google_auth.accessToken,
        idToken: google_auth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Googleサインインに失敗しました: $e');
    }
  }

  // サインアウト
  Future<void> sign_out() async {
    await Future.wait([
      _auth.signOut(),
      _google_sign_in.signOut(),
    ]);
  }

  // ユーザープロフィールを作成
  Future<void> create_user_profile(user_model user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.to_firestore());
    } catch (e) {
      throw Exception('ユーザープロフィールの作成に失敗しました: $e');
    }
  }

  // ユーザープロフィールを取得
  Future<user_model?> get_user_profile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return user_model.from_firestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('ユーザープロフィールの取得に失敗しました: $e');
    }
  }

  // ユーザープロフィールを更新
  Future<void> update_user_profile(user_model user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.to_firestore());
    } catch (e) {
      throw Exception('ユーザープロフィールの更新に失敗しました: $e');
    }
  }

  String _handle_auth_exception(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'パスワードが弱すぎます。';
      case 'email-already-in-use':
        return 'このメールアドレスは既に使用されています。';
      case 'user-not-found':
        return 'ユーザーが見つかりません。';
      case 'wrong-password':
        return 'パスワードが間違っています。';
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません。';
      default:
        return 'エラーが発生しました: ${e.message}';
    }
  }
}
