import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // These will hold the user's data once they log in
  var isLoggedIn = false.obs;
  var userName = "".obs;
  var userEmail = "".obs;
  var userProfilePic = "".obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    // Check if the user is already logged in when the app starts
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _setUserData(currentUser);
    }
  }

  // The main Google Sign-In function
  Future<void> signInWithGoogle() async {
    try {
      // 1. Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // The user canceled the login

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the new credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        _setUserData(user);
        Get.snackbar("Success", "Welcome ${user.displayName}!", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      Get.snackbar("Error", "Failed to sign in. Check console.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // The Logout function
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    isLoggedIn.value = false;
    userName.value = "";
    userEmail.value = "";
    userProfilePic.value = "";
    Get.snackbar("Logged Out", "You have been successfully signed out.");
  }

  // A helper function to save the user data to our observable variables
  void _setUserData(User user) {
    isLoggedIn.value = true;
    userName.value = user.displayName ?? "Unknown User";
    userEmail.value = user.email ?? "No Email";
    userProfilePic.value = user.photoURL ?? "";
  }
}