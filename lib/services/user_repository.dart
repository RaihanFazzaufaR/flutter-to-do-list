import '../models/user_model.dart';

abstract class UserRepository {
  Future<User?> checkLogin(String username, String password);
  Future<void> saveUser(String username, String password);
  Future<bool> updatePassword(int userId, String oldPassword, String newPassword);
  Future<User?> getUserById(int id);
}
