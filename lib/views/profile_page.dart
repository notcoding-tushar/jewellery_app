import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Obx(() {
          // Conditional UI based on Authentication status
          if (authController.isLoggedIn.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.teal,
                  backgroundImage: authController.userProfilePic.value.isNotEmpty
                      ? NetworkImage(authController.userProfilePic.value)
                      : null,
                  child: authController.userProfilePic.value.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 20),
                Text(authController.userName.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(authController.userEmail.value, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  onPressed: () => authController.signOut(),
                )
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 20),
                const Text("Guest User", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Not signed in", style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                  ),
                  icon: Image.network('https://img.icons8.com/color/48/000000/google-logo.png', height: 24),
                  label: const Text("Sign In with Google", style: TextStyle(fontSize: 16)),
                  onPressed: () => authController.signInWithGoogle(),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
