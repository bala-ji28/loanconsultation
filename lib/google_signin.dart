import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
Future signInAccount() async {
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  final googleAuth = await googleUser.authentication;
  final userCredential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  FirebaseAuth.instance.signInWithCredential(userCredential);
}

final currentGoogleUser = FirebaseAuth.instance.currentUser;

Future signOutAccount() async {
  googleSignIn.disconnect();
  await FirebaseAuth.instance.signOut();
}
