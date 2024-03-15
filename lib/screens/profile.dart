import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tourrecs/screens/home.dart';
import 'package:tourrecs/screens/placelist.dart';
import 'package:tourrecs/screens/signin.dart' as signin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourrecs/screens/signin.dart';
import 'package:tourrecs/screens/wishlist.dart';
import 'package:tourrecs/wishlistprovider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // File? _image;
  // Future getImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //
  //   final imageTemporary = File(image.path);
  //
  //   setState(() {
  //     this._image = imageTemporary;
  //   });
  // }

  Future<void> _signOutFromGoogle() async {
    try {
      // Initialize GoogleSignIn
      GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out
      await googleSignIn
          .signOut()
          .then((value) => print("Signout successfull")).then((value) => WishlistProvider().wishlist.clear());

      // Navigate back to the login page
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ));
    } catch (error) {
      print('Error signing out from Google: $error');
    }
  }
  // Future _userDetails()async{
  //   String? username = await GoogleSignIn().currentUser!.displayName;
  //   // String email = await GoogleSignIn().currentUser!.email.toString();
  //   // String photourl = await GoogleSignIn().currentUser!.photoUrl.toString();
  // }
  late User _currentUser;



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadDisplayName();
   // getCurrentUser();
    _getCurrentUser();
  }
  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _name.text = _currentUser.displayName ?? 'No name specified';
    _email.text = _currentUser.email ?? 'nothinh';
    setState(() {
  });
  }
  // Future<void> loadDisplayName() async {
  //   // Retrieve the current user
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     // Retrieve the user document from Firestore
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
  //         'users').doc(user.uid).get();
  //
  //     // Retrieve the display name from the user document
  //     String? displayName = userDoc.get('displayname');
  //
  //     if (displayName != null) {
  //       // Set the display name in the text field
  //       _name.text = displayName;
  //     }
  //   }
  // }
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  //CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  //User _user =  FirebaseAuth.instance.currentUser!;
 // String? name = _user.displayName;


  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 230,
                image: AssetImage("assets/images/1976998-1.jpg"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.15,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: _currentUser.photoURL != null
                        ? NetworkImage(_currentUser.photoURL!)
                        : AssetImage('assets/images/download.png') as ImageProvider,
                    // You can replace 'default_profile.jpg' with your default profile image
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.015,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child:TextField(

                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    readOnly: true,
                  ),),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.015,
                ),

                Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child:TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      readOnly: true,
                    ),),
                //Text(FirebaseFirestore.instance.collection("users").doc().ge),
                //Container(height: 100, width: 200, child: Card()),
                SizedBox(height: 40,),
                Container(
                  height: 70,
                  width: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure you want to Sign out?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await _signOutFromGoogle();
                                      

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignInPage(),
                                          ));
                                    },
                                    child: Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"))
                              ],
                            );
                          },
                        );
                      },
                      child: Text("SignOut")),
                ),
              ],
            ),
            Positioned(
              width: MediaQuery.sizeOf(context).width * 0.97,
              bottom: 8,
              left: MediaQuery.sizeOf(context).width * 0.015,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.085,
                //width: MediaQuery.sizeOf(context).width*0.92,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade700,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 20)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            )),
                        icon: Icon(Icons.home, size: 32)),
                    IconButton(
                      onPressed: () {
                        showSearch(context: context, delegate: CitySearch());
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Wishlist(),
                            )),
                        icon: Icon(Icons.favorite, size: 32)),
                    GestureDetector(
                      onTap: () =>  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          )),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundImage: _currentUser.photoURL != null
                            ? NetworkImage(_currentUser.photoURL!)
                            : AssetImage('assets/images/download.png') as ImageProvider,
                        // You can replace 'default_profile.jpg' with your default profile image
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CitySearch extends SearchDelegate<String> {
  final CollectionReference citiesRef =
  FirebaseFirestore.instance.collection('City');
  final CollectionReference placesRef =
  FirebaseFirestore.instance.collection('Places');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Future<List<QueryDocumentSnapshot>> _fetchCityResults() async {
    final querySnapshot = await citiesRef
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .limit(5)
        .get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> _fetchPlaceResults() async {
    final querySnapshot = await placesRef
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .limit(5)
        .get();
    return querySnapshot.docs;
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: _fetchResults(),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container( height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 230,
                      image: AssetImage("assets/images/1976998-1.jpg"),
                      fit: BoxFit.cover)),child: Center(child: CircularProgressIndicator()));
        }

        final List<QueryDocumentSnapshot> allResults = snapshot.data ?? [];

        return Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 230,
                  image: AssetImage("assets/images/1976998-1.jpg"),
                  fit: BoxFit.cover)),
          child: Stack(
            children: [
              ListView(
                children: allResults.map((QueryDocumentSnapshot document) {
                  final data = document.data() as Map<String, dynamic>;
                  Future<ImageProvider> _getImage() async {
                    final url = "${data['cityimage']}";
                    final image = NetworkImage(url);
                    await precacheImage(image, context); // Pre-cache the image
                    return image;
                  }

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(data['name']),
                      //:MyCircleAvatar(imageUrl: "${data['cityimage']}"),
                      leading: FutureBuilder(
                        future: _getImage(),
                        // Method to fetch image asynchronously
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: 20,
                              child: CircularProgressIndicator(),
                              backgroundColor: Colors.white,
                            );
                          } else if (snapshot.hasError) {
                            return CircleAvatar(
                              radius: 20,
                              child: Icon(Icons
                                  .error), // Display error icon if image loading fails
                            );
                          } else {
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage:
                              NetworkImage("${data['cityimage']}"),
                            );
                          }
                        },
                      ),

                      // leading: CircleAvatar(radius: 20,backgroundImage: NetworkImage("${data['cityimage']}"),),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlaceList(
                              cityId: '${data['id']}',
                              cityName: '${data['name']}'),
                        ));
                        // Handle the tap event as per your requirement
                        // For example, navigate to a details screen for the city/place.
                      },
                    ),
                  );
                }).toList(),
              ),
              // Positioned(
              //   width: MediaQuery.sizeOf(context).width * 0.97,
              //
              //   bottom: 8,
              //   left: 6,
              //   // left: MediaQuery.sizeOf(context).width*0.001,
              //
              //   child: Container(
              //     height: MediaQuery.sizeOf(context).height * 0.085,
              //     //width: MediaQuery.sizeOf(context).width*0.92,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Colors.grey.shade700,
              //             blurStyle: BlurStyle.outer,
              //             blurRadius: 20)
              //       ],
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         IconButton(
              //             onPressed: () => Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => Home(),
              //                 )),
              //             icon: Icon(Icons.home,
              //                 size: 32)),
              //         IconButton(
              //           onPressed: () {
              //             showSearch(context: context, delegate: CitySearch());
              //           },
              //           icon: Icon(
              //             Icons.search,
              //             color: Colors.black,
              //           ),
              //         ),
              //
              //         IconButton(
              //             onPressed: () => Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => Wishlist(),
              //                 )),
              //             icon: Icon(Icons.favorite, size: 32)),
              //         IconButton(
              //             onPressed: () => Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => ProfilePage(),
              //                 )),
              //             icon: Icon(Icons.account_circle_rounded,
              //                 size: 32)),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<List<QueryDocumentSnapshot>> _fetchResults() async {
    // final cityResults = await _fetchCityResults();
    // final placeResults = await _fetchPlaceResults();
    // return [...cityResults, ...placeResults];
    final cityResults = await _fetchCityResults();
    final placeResults = await _fetchPlaceResults();
    return cityResults;
  }
}
