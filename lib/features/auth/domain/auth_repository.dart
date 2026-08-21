import 'package:final_flutter/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  // دوال المصادقة الأساسية
  Future<UserModel> login(String identifier, String password);
  Future<void> register(String name, String email, String password);
  Future<void> verifyOtp(String contact, String code);
  Future<void> resendOtp(String contact);
  Future<void> logout();
  Future<UserModel> getProfile();
}
