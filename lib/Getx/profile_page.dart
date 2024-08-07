import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:receive_the_product/Getx/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_the_product/Getx/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
          future: authController.checkVerificationStatus(
            GetStorage().read('token') ?? '',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.data!) {
              return Center(child: Text('Error: You are not verified'));
            }

            final user = authController.getUser();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.avatar.isNotEmpty == true ? NetworkImage(user!.avatar) : null,
                  child: user?.avatar.isEmpty == true ? Icon(Icons.person, size: 50) : null,
                ),
                SizedBox(height: 16),
                Text('Name: ${user?.name ?? 'No name'}'),
                Text('Email: ${user?.email ?? 'No email'}'),
                Text('Family: ${user?.family ?? 'No family'}'),
                Text('Availability: ${user?.availability.join(', ') ?? 'No availability'}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
