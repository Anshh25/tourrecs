import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:tourrecs/firebase_config/auth_services.dart';
import 'package:tourrecs/screens/home.dart';

import 'adminlogin.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

  User? _user;
  late GoogleSignIn _googleSignIn;
  late FirebaseAuth _auth = FirebaseAuth.instance;
  late FirebaseFirestore _firestore;

  //var token, email, phoneNumber, name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    _googleSignIn = GoogleSignIn();

    _firestore = FirebaseFirestore.instance;
    //checkCurrentUser();
  }

  Future<User?> _handleSignIn() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Add user details to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'displayname': user.displayName,
            'email': user.email,
            'photourl': user.photoURL
            // Add more user details as needed
          });

          return user;
        } else {
          throw Exception('Sign in failed');
        }
      } else {
        throw Exception('Sign in aborted');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // void checkCurrentUser() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home()),
  //     );
  //     // User is already signed in, navigate to the home page
  //   }
  // }
  //
  // Future<void> _signInWithGoogle() async {
  //   try {
  //     // Initialize GoogleSignIn
  //     GoogleSignIn googleSignIn = GoogleSignIn();
  //
  //     // Attempt to sign in
  //     GoogleSignInAccount? account = await googleSignIn.signIn();
  //
  //     // If successful, save user credentials and navigate to the next page
  //     if (account != null) {
  //       // Save user credentials to Firestore
  //       await saveUserData(account);
  //
  //       // Navigate to the next page
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => Home()),
  //       );
  //     } else {
  //       print('User cancelled the sign-in process');
  //     }
  //   } catch (error) {
  //     print('Error signing in with Google: $error');
  //   }
  // }
  //
  // Future<void> saveUserData(GoogleSignInAccount account) async {
  //   try {
  //     // Access Firestore instance
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //     // Create a reference to the user document using the user's ID
  //     DocumentReference userRef = firestore.collection('users').doc(account.id);
  //
  //     // Check if the user document already exists
  //     DocumentSnapshot userSnapshot = await userRef.get();
  //     if (!userSnapshot.exists) {
  //       // If the user document does not exist, create it
  //       await userRef.set({
  //         'displayname': account.displayName,
  //         'email': account.email,
  //         'photourl': account.photoUrl
  //         // Add more user data as needed
  //       });
  //     }
  //   } catch (error) {
  //     print('Error saving user data: $error');
  //   }
  // }
  //
  // Future<void> google() async {
  //   User? res = await signWithGoogle().then((value) {
  //     print(value);
  //
  //     var userToken = FirebaseAuth.instance.currentUser?.getIdToken(false);
  //
  //     userToken?.then((v) {
  //       print("inside value");
  //       token = v.toString();
  //       //setState(() {});
  //       print('token: ${token}');
  //
  //       var userData = {
  //         'uid': value?.uid.toString(),
  //         'email': value?.email.toString(),
  //         'phoneNumber': value?.phoneNumber.toString(),
  //         'profilephoto': value?.photoURL.toString(),
  //         'isEmailVerified': value?.emailVerified.toString(),
  //         'creationTime': value?.metadata.creationTime.toString(),
  //         'lastSignInTime': value?.metadata.lastSignInTime.toString(),
  //         'displayName': value?.displayName.toString(),
  //       };
  //       var userDataJson = jsonEncode(userData);
  //       print('userData: $userDataJson');
  //       email = value?.email.toString();
  //       phoneNumber = value?.phoneNumber.toString();
  //       name = value?.displayName.toString();
  //       print(name);
  //     });
  //   }).onError((error, stackTrace) {
  //     print('Error ${error.toString()}');
  //   });
  // }

  Future<void> addAdminToFirestore(name, pass) async {
    try {
      await FirebaseFirestore.instance.collection('admins').doc().set({
        'name': name,
        'password': pass,
      });
      print('Admin added to Firestore successfully');
    } catch (e) {
      print('Error adding admin to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 240,
              image: AssetImage("assets/images/1976998-1.jpg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 27.0),
              child: Image.asset(
                "assets/images/applogo.png",
                height: 110,
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.002,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text("tourRecs.",
                  style: GoogleFonts.oleoScript(
                      fontSize: 35, fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text("Hi👋,",
                  style: GoogleFonts.aBeeZee(
                      fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 28.0,
              ),
              child: Text("Join to the adventure Trips!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700)),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.06,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {


                  User? user = await _handleSignIn();
                  Container(
                    width: MediaQuery.sizeOf(context).width*1,
                    height: MediaQuery.sizeOf(context).height*1,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  );


                  if (user != null) {
                    // Navigate to another screen or perform additional actions
                    print('Signed in as: ${user.displayName}');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home(),
                    ));
                  } else {

                    // Handle sign-in failure
                    print('Sign-in failed');
                  }

                  // await google().then((value) =>
                  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //       builder: (context) => Home(),
                  //     )));
                  //await saveUserData(account);
                },
                // onTap: () async {
                //   // LoadingView();
                //   await _auth.then((isSuccess) {
                //     if (isSuccess) {
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => HomePage(),
                //         ),
                //       );
                //     }
                //   }).catchError((error, stackTrace) {
                //     Fluttertoast.showToast(msg: error.toString());
                //     authProvider.handleException();
                //   });
                // },,
                child: Container(
                  height: 64,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/google.png", height: 35),
                      Text(
                        "    Sign in with Google",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              // height: MediaQuery.sizeOf(context).height * 0.06,
              height: 15,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminLogin(),
                      ));
                  // addAdminToFirestore("devansh","dev1234");
                },
                child: Container(
                  height: 64,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.black,
                      ),
                      Text(
                        "    Admin login",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                      text: "By proceeding, you agree to our ",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 12)),
                  TextSpan(
                    text: "Terms of Use",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
