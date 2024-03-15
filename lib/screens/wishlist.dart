import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourrecs/screens/home.dart';
import 'package:tourrecs/screens/placelist.dart';
import 'package:tourrecs/screens/profile.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late User _currentUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _wishlistStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    _wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('wishlist')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          "Wishlist",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 230,
                image: AssetImage("assets/images/1976998-1.jpg"),
                fit: BoxFit.cover)),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _wishlistStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No items in wishlist'),
              );
            }
            return Stack(
              children: [
                ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot<Map<String, dynamic>> doc) {
                    String placeId = doc.id;
                    String placeName = doc[
                        'placeName']; // Assuming 'placeName' is stored in the wishlist document
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: ListTile(
                        title: Text(placeName),
                        // Add more details if needed
                      ),
                    );
                  }).toList(),
                ),
                Positioned(
                  width: MediaQuery.sizeOf(context).width * 0.97,

                  bottom: 8,
                  left: 6,
                  // left: MediaQuery.sizeOf(context).width*0.001,

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
                            showSearch(
                                context: context, delegate: CitySearch());
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
            );
          },
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
