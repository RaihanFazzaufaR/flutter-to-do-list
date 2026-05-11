import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_repository.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  
  bool _isLoading = true;
  bool _isLoggedIn = false;
  User? _currentUser;

  AuthProvider(this._userRepository) {
    checkLoginState();
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  int? get userId => _currentUser?.id;
  String? get username => _currentUser?.username;

  Future<void> checkLoginState() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(AppConstants.keyUserId);

    if (id != null) {
      final user = await _userRepository.getUserById(id);
      if (user != null) {
        _isLoggedIn = true;
        _currentUser = user;
      } else {
        _isLoggedIn = false;
        _currentUser = null;
      }
    } else {
      _isLoggedIn = false;
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final user = await _userRepository.checkLogin(username, password);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyUserId, user.id);

      _isLoggedIn = true;
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return "User not logged in";
    
    _isLoading = true;
    notifyListeners();

    final success = await _userRepository.updatePassword(_currentUser!.id, oldPassword, newPassword);

    _isLoading = false;
    notifyListeners();

    if (success) {
      return null; // Success
    } else {
      return "Incorrect old password";
    }
  }
}
