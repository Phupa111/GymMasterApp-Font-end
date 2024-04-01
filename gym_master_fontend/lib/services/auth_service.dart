import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to get the Google user
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        // User cancelled the login
        return null;
      }

      // Get the authentication object for the user
      final GoogleSignInAuthentication googleAuth = await gUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Ensure user selects an account every time
      await googleSignIn.signOut();
      // Use the credential to sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
