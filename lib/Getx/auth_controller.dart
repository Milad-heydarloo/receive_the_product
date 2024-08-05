import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:receive_the_product/Getx/user_model.dart';
import 'dart:convert';  // برای jsonDecode

class AuthController extends GetxController {
  final box = GetStorage();
  final pb = PocketBase('https://saater.liara.run');

  @override
  void onInit() {
    super.onInit();
  }

  void setUser(User user) {
    final userJson = jsonEncode(user.toJson());
    box.write('user', userJson);
    update(['user']);
  }

  User? getUser() {
    final userJson = box.read('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  void clearUser() {
    box.remove('user');
    box.remove('token');
    update(['user']);
  }

  void logout() {
    clearUser();
    Get.offAllNamed('/login');
  }

  Future<void> checkLoginStatus() async {
    final token = box.read('token');
    if (token != null) {
      final isVerified = await checkVerificationStatus(token);
      if (isVerified) {
        Get.offAllNamed('/home');
      } else {
        clearUser();
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final authData = await pb.collection('users').authWithPassword(email, password);
      final userJson = authData.record!.toJson();
      final token = authData.token;
      final user = User.fromJson(userJson);

      if (user.verified) {
        box.write('token', token);
        setUser(user);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'You are not verified');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid email or password');
    }
  }

  Future<bool> checkVerificationStatus(String token) async {
    try {
      final body = <String, dynamic>{
        "token": token,
      };
      final authData = await pb.collection('users').authRefresh(body: body);

      final userJson = authData.record!.toJson();
      final user = User.fromJson(userJson);

      if (user.verified) {
        return true;
      } else {
        clearUser();
        Get.offAllNamed('/login');
        return false;
      }
    } catch (e) {
      clearUser();
      Get.offAllNamed('/login');
      return false;
    }
  }
}
