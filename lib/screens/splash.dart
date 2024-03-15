import 'package:flutter/material.dart';
import 'package:tourrecs/screens/home.dart';
import 'package:tourrecs/screens/onboarding.dart';
// import 'package:chatterly/constants/color_constants.dart';
// import 'package:chatterly/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
//
// import 'pages.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //print('inside splash');
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
                context,
                 MaterialPageRoute(builder: (context) => Onboarding()));
      // just delay for showing this slash page clearer because it too fast
      //checkSignedIn();
    });
  }

  // void checkSignedIn() async {
  //   AuthProvider authProvider = context.read<AuthProvider>();
  //   bool isLoggedIn = await authProvider.isLoggedIn();
  //   if (isLoggedIn) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //     return;
  //   }
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/applogo.png",
              width: 120,
              height: 120,
            ),
            SizedBox(height: 20),
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
