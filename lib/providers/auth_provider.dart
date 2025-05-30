import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class auth_provider with ChangeNotifier {
  final auth_service _auth_service = auth_service();
  
  User? _user;
  user_model? _user_profile;
  bool _is_loading = true;
  String? _error;

  User? get user => _user;
  user_model? get user_profile => _user_profile;
  bool get is_loading => _is_loading;
  String? get error => _error;
  bool get is_authenticated => _user != null;

  auth_provider() {
    _init();
  }

  void _init() {
    _auth_service.auth_state_changes.listen((User? user) async {
      _user = user;
      if (user != null) {
        await _load_user_profile(user.uid);
      } else {
        _user_profile = null;
      }
      _is_loading = false;
      notifyListeners();
    });
  }

  Future<void> _load_user_profile(String uid) async {
    try {
      _user_profile = await _auth_service.get_user_profile(uid);
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<bool> sign_up_with_email_and_password(String email, String password) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      final credential = await _auth_service.sign_up_with_email_and_password(email, password);
      return credential != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> sign_in_with_email_and_password(String email, String password) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      final credential = await _auth_service.sign_in_with_email_and_password(email, password);
      return credential != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> sign_in_with_google() async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      final credential = await _auth_service.sign_in_with_google();
      return credential != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> create_user_profile(user_model user_model_instance) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      await _auth_service.create_user_profile(user_model_instance);
      _user_profile = user_model_instance;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<bool> update_user_profile(user_model user_model_instance) async {
    try {
      _is_loading = true;
      _error = null;
      notifyListeners();

      await _auth_service.update_user_profile(user_model_instance);
      _user_profile = user_model_instance;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _is_loading = false;
      notifyListeners();
    }
  }

  Future<void> sign_out() async {
    try {
      await _auth_service.sign_out();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clear_error() {
    _error = null;
    notifyListeners();
  }
}
