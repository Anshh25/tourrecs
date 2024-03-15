import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourrecs/cityprovider.dart';
import 'package:tourrecs/placeprovider.dart';
import 'package:tourrecs/screens/adminlogin.dart';
import 'package:tourrecs/screens/adminpage.dart';
import 'package:tourrecs/screens/citytable.dart';
import 'package:tourrecs/screens/home.dart';
import 'package:tourrecs/screens/placelist.dart';
import 'package:tourrecs/screens/placetable.dart';
import 'package:tourrecs/screens/populardestinations.dart';
import 'package:tourrecs/screens/profile.dart';
import 'package:tourrecs/screens/signin.dart';
import 'package:tourrecs/screens/splash.dart';
import 'package:tourrecs/screens/usertable.dart';
import 'package:tourrecs/wishlistprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'tourRecs',
      options: FirebaseOptions(
          apiKey: "AIzaSyBCt3DPKgiE7z5HgqTp9tNKN1c7aXlv6KU",
          appId: "1:802124167346:android:55d47738ad9ada0c2531ab",
          messagingSenderId: "802124167346",
          //databaseURL: "https://tourrecs-default-rtdb.firebaseio.com",
          projectId: "tourrecs",
          storageBucket: "tourrecs.appspot.com"));
  runApp(
    MyApp(),
  );
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WishlistProvider(),),
        ChangeNotifierProvider(create: (context) => CityProvider(),),
        ChangeNotifierProvider(create: (context) => PlaceProvider(),)

      ],
      child: MaterialApp(
          theme: ThemeData(
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.black12),
                    foregroundColor: MaterialStatePropertyAll(Colors.black))),
          ),
          debugShowCheckedModeBanner: false,
          title: 'tourRecs',
          home: SplashPage()),
    );
  }
}
