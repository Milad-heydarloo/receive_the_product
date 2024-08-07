import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:receive_the_product/Getx/user_model.dart';
import 'dart:convert';

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
    update(['user']);
  }

  void logout() {
    clearUser();
    Get.offAllNamed('/login');
  }

  Future<void> checkLoginStatus() async {
    final userJson = box.read('user');
    if (userJson != null) {
      final user = User.fromJson(userJson);
      if (user.verified) {
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
      final user = User.fromJson(userJson);

      // اضافه کردن پسورد به اطلاعات کاربر
      user.password = password; // ذخیره کردن پسورد

      if (user.verified) {
        // ذخیره اطلاعات کاربر با پسورد
        box.write('user', user.toJson());
        setUser(user);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'You are not verified');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid email or password');
    }
  }

  // Future<User?> getUserFromServerOrStorage() async {
  //   final userJson = box.read('user');
  //   if (userJson != null) {
  //     try {
  //       final user = User.fromJson(jsonDecode(userJson));
  //       if (user.verified) {
  //         return user;
  //       } else {
  //         clearUser();
  //         return null;
  //       }
  //     } catch (e) {
  //       clearUser();
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  // فرض بر این است که متد checkVerificationStatus که در فایل profile_page.dart استفاده می‌شود، به صورت زیر باشد
  Future<bool> checkVerificationStatus() async {
    bool check = false; // مقداردهی اولیه به false

    final userJson = box.read('user');
    if (userJson == null) {
      Get.snackbar('Error', 'No user data found. Please login again.');
      return check; // در صورتی که اطلاعات کاربر وجود نداشته باشد، false برگردانده می‌شود
    }

    final usersa = User.fromJson(jsonDecode(userJson));

    try {
      final authData = await pb.collection('users').authWithPassword(usersa.email, usersa.password);
      final fetchedUserJson = authData.record!.toJson();
      final user = User.fromJson(fetchedUserJson);

      if (user.verified) {
        // وضعیت تأیید درست است
        check = true;
        // اطلاعات کاربر را به روز کنید و به صفحه خانه هدایت کنید (اختیاری)
        // box.write('user', fetchedUserJson); // ذخیره اطلاعات کاربر به جای توکن
        // setUser(user);
        // Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', 'You are not verified');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid email or password');
    }

    return check; // در پایان متد، مقدار check برگردانده می‌شود
  }

}
