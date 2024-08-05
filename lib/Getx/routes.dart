import 'package:get/get.dart';
import 'package:receive_the_product/Getx/testGetx/homepage.dart';
import 'package:receive_the_product/Getx/loginpage.dart';
import 'package:receive_the_product/Getx/profile_page.dart';

import 'package:receive_the_product/main.dart';




class Routes {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String splash = '/splash';

  static List<GetPage> getPages = [
    GetPage(name: home, page: () => LocationPickerScreen()),
    GetPage(name: profile, page: () => ProfilePage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: splash, page: () => SplashPage()),
  ];
}


