import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

// Future<void> signUpWithPhoneNumber ({required String fullPhoneNum, required void Function(String, int?) codeSent}) async{
//   return await _auth.verifyPhoneNumber(
//     phoneNumber: fullPhoneNum,
//     verificationCompleted: (_){},
//     verificationFailed: (e){
//       toast(e.toString());
//     },
//     codeSent: codeSent,
//     codeAutoRetrievalTimeout: (e){
//       print('error: ${e.toString()}');
//       toast(e.toString());
//     },
//   );
// }

Future<User?> signWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final googleAuth = await googleSignInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await FirebaseAuth.instance.signInWithCredential(credential);

    final User user = result.user!;

    return user;
  } else {
    return null;
  }
}


