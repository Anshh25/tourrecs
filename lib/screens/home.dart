import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tourrecs/firebase_config/auth_services.dart';
import 'package:tourrecs/placeprovider.dart';
import 'package:tourrecs/screens/citytable.dart';
import 'package:tourrecs/screens/placelist.dart';
import 'package:tourrecs/screens/populardestinations.dart';
import 'package:tourrecs/screens/profile.dart';
import 'package:tourrecs/screens/signin.dart';
import 'package:tourrecs/screens/wishlist.dart';

import '../cityprovider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  late User _currentUser;
  TextEditingController _name = TextEditingController();
  // String name = '';
  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
    // String name  = _currentUser.displayName ?? 'No name specified';

    setState(() {});
  }


    Future<SignInPage> handleSignOut() async {
    await firebaseAuth.signOut();
    // Sign out with google
    await googleSignIn.signOut();

    return SignInPage();
  }

  //final FirebaseAuth _auth = FirebaseAuth.instance;
 late final CityProvider cityProvider ;
 late final PlaceProvider placeProvider ;
 // final PlaceProvider placeProvider = PlaceProvider();

  //final cityProvider =CityProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
    cityProvider= Provider.of<CityProvider>(context, listen: false);
    placeProvider= Provider.of<PlaceProvider>(context, listen: false);

    placeProvider.fetchPlaceDetails();
    cityProvider.fetchCityDetails();

  }

  // Future<void> _fetchCityDetails() async {
  //   //await cityProvider.fetchCityDetails();
  // }
 // FirebaseFirestore.instance.collection('Places').doc().toString().length as List;


  @override
  Widget build(BuildContext context) {
    // final cityProvider = Provider.of<CityProvider>(context);



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 230,
                  image: AssetImage("assets/images/1976998-1.jpg"),
                  fit: BoxFit.cover)),

          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(

                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome,\n ${_currentUser.displayName ?? 'Guest'}',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),textAlign: TextAlign.end,
                  ),
                  SizedBox(width: 5,),
                  Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: _currentUser.photoURL != null
                          ? NetworkImage(_currentUser.photoURL!)
                          : AssetImage('assets/images/download.png') as ImageProvider,
                      // You can replace 'default_profile.jpg' with your default profile image
                    ),
                  ),

                  // IconButton(
                  //     onPressed: () async {
                  //       await _auth.signOut();
                  //       await GoogleSignIn().signOut();
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => SignInPage()),
                  //       );
                  //     },
                  //     icon: Icon(Icons.account_circle_rounded),
                  //     iconSize: 50),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Explore",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.sizeOf(context).height * 0.058,
                    width: MediaQuery.sizeOf(context).width * 0.33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 16,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 1),
                height: MediaQuery.sizeOf(context).height * 0.27,

                child: Consumer<CityProvider>(
                  builder: (context, cityProvider, _) {



                    print("inside cityproviderlist");



                    if (cityProvider.cityDetailss.isEmpty) {
                      print("Errrrorrrrrrr");
                      // Return a loading indicator if the data is being fetched
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Use cityDetails to build your UI
                    return ListView.builder(
                      itemCount: cityProvider.cityDetailss.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var cityData = cityProvider.cityDetails[index];
                        print("hiiiiiiiiiiiiiiiii");

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlaceList(cityId: '${cityData['id']}', cityName: '${cityData['name']}')),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            margin: EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: "${cityData['cityimage']}",
                                    height: MediaQuery.sizeOf(context).height * 0.3,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  height: 220,
                                  width: 150,
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10, left: 8, right: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "${cityData['name']}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 0,
                                                ),
                                                // Text(
                                                //   "${data.length} Places",
                                                //   style: TextStyle(
                                                //       color: Colors.white,
                                                //       fontWeight: FontWeight.w600,
                                                //       fontSize: 13),
                                                // )
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10, right: 8),
                                            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: Colors.white38,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${cityData['rating']}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // child: StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('City')
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.connectionState ==
                //         ConnectionState.waiting) {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //     if (snapshot.hasError) {
                //       return Center(
                //         child: Text('Error: ${snapshot.error}'),
                //       );
                //     }
                //     // Check if the query snapshot has no data
                //     if (snapshot.data!.docs.isEmpty) {
                //       return Center(
                //         child: Text('No cities found'),
                //       );
                //     }
                //     final cities = snapshot.data!.docs;
                //     List<Map<String, dynamic>> placesList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                //
                //
                //
                //
                //
                //
                //     return ListView.builder(
                //       itemCount: snapshot.data!.docs.length,
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context, index) {
                //         final cityData = snapshot.data!.docs[index].data()
                //         as Map<String, dynamic>;
                //         var data = placesList[index];
                //
                //
                //
                //
                //         return GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               // MaterialPageRoute(builder: (context) => PopularDestinations(id: '${cityData['id']}', collection: 'City')),
                //               MaterialPageRoute(builder: (context) => PlaceList(cityId: '${cityData['id']}', cityName: '${cityData['name']}')),
                //             );
                //           },
                //           child: Container(
                //             alignment: Alignment.center,
                //             height: MediaQuery.sizeOf(context).height * 0.3,
                //             margin: EdgeInsets.only(right: 8),
                //             child: Stack(
                //               children: [
                //                 ClipRRect(
                //                   borderRadius: BorderRadius.circular(16),
                //                   child: CachedNetworkImage(
                //                     imageUrl:
                //                     "${cityData['cityimage']}" ,
                //                     height: MediaQuery.sizeOf(context).height * 0.3,
                //                     width: 150,
                //                     fit: BoxFit.cover,
                //                   ),
                //                 ),
                //                 Container(
                //                   height: 220,
                //                   width: 150,
                //                   child: Column(
                //                     children: [
                //
                //                       Spacer(),
                //                       Row(
                //                         children: [
                //                           Container(
                //                             margin: EdgeInsets.only(
                //                                 bottom: 10, left: 8, right: 8),
                //                             child: Column(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.start,
                //                               children: [
                //                                 Container(
                //                                   child: Text(
                //                                     "${cityData['name']}",
                //                                     style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontWeight: FontWeight.w600,
                //                                         fontSize: 16),
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 0,
                //                                 ),
                //                                 // Text(
                //                                 //   "${data.length} Places",
                //                                 //   style: TextStyle(
                //                                 //       color: Colors.white,
                //                                 //       fontWeight: FontWeight.w600,
                //                                 //       fontSize: 13),
                //                                 // )
                //                               ],
                //                             ),
                //                           ),
                //                           Spacer(),
                //                           Container(
                //                               margin: EdgeInsets.only(
                //                                   bottom: 10, right: 8),
                //                               padding: EdgeInsets.symmetric(
                //                                   horizontal: 3, vertical: 7),
                //                               decoration: BoxDecoration(
                //                                   borderRadius:
                //                                       BorderRadius.circular(3),
                //                                   color: Colors.white38),
                //                               child: Column(
                //                                 children: [
                //                                   Text(
                //                                     "${cityData['rating']}",
                //                                     style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontWeight: FontWeight.w600,
                //                                         fontSize: 13),
                //                                   ),
                //                                   SizedBox(
                //                                     height: 2,
                //                                   ),
                //                                   Icon(
                //                                     Icons.star,
                //                                     color: Colors.white,
                //                                     size: 20,
                //                                   )
                //                                 ],
                //                               ))
                //                         ],
                //                       )
                //                     ],
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   }
                // ),
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Popular Places",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        right: 10, left: 10, bottom: 10, top: 5),
                    height: MediaQuery.sizeOf(context).height * 0.055,
                    width: MediaQuery.sizeOf(context).width * 0.53,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(186),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 10,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.375,
                  width: MediaQuery.sizeOf(context).width * 0.99,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            width: MediaQuery.sizeOf(context).width * 0.97,
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(color: Colors.grey,blurStyle: BlurStyle.normal,blurRadius: 10)
                              // ],
                            ),
                            child: Consumer<PlaceProvider>(builder: (context, placeProvider, _) {
                             // placeProvider.fetchPlaceDetails();
                              if(placeProvider.placeDetails.isEmpty){
                                return Center(child: CircularProgressIndicator(),);

                              }
                              return  ListView.builder(
                                itemCount: placeProvider.placeDetails.length,
                                itemBuilder: (context, index) {
                                  final placeData = placeProvider.placeDetails[index];
                                 // final placeData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                                  return GestureDetector(
                                    onTap: () =>  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PopularDestinations(id: '${placeData['id']}', collection: 'Places',name: '${placeData['name']}',)),
                                    ),
                                    child: Container(

                                      margin: EdgeInsets.only(bottom: 8),
                                      width: MediaQuery.sizeOf(context).width * 0.97,
                                      decoration: BoxDecoration(
                                          color: Color(0xffE9F2F9),
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      child: Stack(
                                          children:[ Row(
                                            mainAxisSize: MainAxisSize.min,

                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    bottomLeft: Radius.circular(20)),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  "${placeData['image']}",
                                                  width: 110,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,

                                                ),

                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(overflow: TextOverflow.ellipsis,
                                                      "${placeData['name']}",
                                                      style: TextStyle(overflow: TextOverflow.ellipsis,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                          color: Color(0xff4E6059)),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(overflow: TextOverflow.ellipsis,
                                                      "${placeData['cityname']}",
                                                      style: TextStyle(overflow: TextOverflow.ellipsis,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w400,
                                                          color: Color(0xff89A097)),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    // Text(
                                                    //   "\$ 245.50",
                                                    //   style: TextStyle(
                                                    //       fontSize: 16,
                                                    //       fontWeight: FontWeight.w600,
                                                    //       color: Color(0xff4E6059)),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 60,
                                              ),

                                            ],
                                          ),
                                            Positioned(
                                              right: 5,
                                              top: 10,

                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0, right: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4, vertical: 12),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(6),
                                                      color: Color(0xff139157)),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${placeData['rating']}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                        size: 20,
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ]
                                      ),
                                    ),
                                  );
                                },
                              );

                            },),
                            // child: StreamBuilder(
                            //   stream: FirebaseFirestore.instance.collection("Places").snapshots(),
                            //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Center(
                            //         child: CircularProgressIndicator(),
                            //       );
                            //     }
                            //     if (snapshot.hasError) {
                            //       return Center(
                            //         child: Text('Error: ${snapshot.error}'),
                            //       );
                            //     }
                            //     // Check if the query snapshot has no data
                            //     if (snapshot.data!.docs.isEmpty) {
                            //       return Center(
                            //         child: Text('No Places found'),
                            //       );
                            //     }
                            //     final places = snapshot.data!.docs;
                            //     return ListView.builder(
                            //       itemCount: snapshot.data!.docs.length,
                            //       itemBuilder: (context, index) {
                            //         final place = places[index];
                            //         final placeData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            //         return GestureDetector(
                            //           onTap: () =>  Navigator.push(
                            //             context,
                            //             MaterialPageRoute(builder: (context) => PopularDestinations(id: '${placeData['id']}', collection: 'Places',name: '${placeData['name']}',)),
                            //           ),
                            //           child: Container(
                            //
                            //             margin: EdgeInsets.only(bottom: 8),
                            //              width: MediaQuery.sizeOf(context).width * 0.97,
                            //             decoration: BoxDecoration(
                            //                 color: Color(0xffE9F2F9),
                            //                 borderRadius:
                            //                     BorderRadius.circular(20)),
                            //             child: Stack(
                            //               children:[ Row(
                            //                 mainAxisSize: MainAxisSize.min,
                            //
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   ClipRRect(
                            //                     borderRadius: BorderRadius.only(
                            //                         topLeft: Radius.circular(20),
                            //                         bottomLeft: Radius.circular(20)),
                            //                     child: CachedNetworkImage(
                            //                       imageUrl:
                            //                       "${placeData['image']}",
                            //                       width: 110,
                            //                       height: 80,
                            //                       fit: BoxFit.cover,
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     padding: EdgeInsets.only(left: 10,
                            //
                            //                     ),
                            //
                            //                     child: Column(
                            //                       mainAxisSize: MainAxisSize.min,
                            //                       crossAxisAlignment:
                            //                           CrossAxisAlignment.start,
                            //                       children: [
                            //                         Text(overflow: TextOverflow.ellipsis,
                            //                           "${placeData['name']}",
                            //                           style: TextStyle(overflow: TextOverflow.ellipsis,
                            //                               fontSize: 16,
                            //                               fontWeight: FontWeight.w600,
                            //                               color: Color(0xff4E6059)),
                            //                         ),
                            //                         SizedBox(
                            //                           height: 3,
                            //                         ),
                            //                         Text(overflow: TextOverflow.ellipsis,
                            //                           "${placeData['cityname']}",
                            //                           style: TextStyle(overflow: TextOverflow.ellipsis,
                            //                               fontSize: 13,
                            //                               fontWeight: FontWeight.w400,
                            //                               color: Color(0xff89A097)),
                            //                         ),
                            //                         SizedBox(
                            //                           height: 6,
                            //                         ),
                            //                         // Text(
                            //                         //   "\$ 245.50",
                            //                         //   style: TextStyle(
                            //                         //       fontSize: 16,
                            //                         //       fontWeight: FontWeight.w600,
                            //                         //       color: Color(0xff4E6059)),
                            //                         // )
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   SizedBox(
                            //                     width: 60,
                            //                   ),
                            //
                            //                 ],
                            //               ),
                            //                 Positioned(
                            //                   right: 5,
                            //                   top: 10,
                            //
                            //                   child: Container(
                            //                       margin: EdgeInsets.only(
                            //                           bottom: 0, right: 8),
                            //                       padding: EdgeInsets.symmetric(
                            //                           horizontal: 4, vertical: 12),
                            //                       decoration: BoxDecoration(
                            //                           borderRadius:
                            //                           BorderRadius.circular(6),
                            //                           color: Color(0xff139157)),
                            //                       child: Column(
                            //                         children: [
                            //                           Text(
                            //                             "${placeData['rating']}",
                            //                             style: TextStyle(
                            //                                 color: Colors.white,
                            //                                 fontWeight:
                            //                                 FontWeight.w600,
                            //                                 fontSize: 12),
                            //                           ),
                            //                           SizedBox(
                            //                             height: 2,
                            //                           ),
                            //                           Icon(
                            //                             Icons.star,
                            //                             color: Colors.white,
                            //                             size: 20,
                            //                           )
                            //                         ],
                            //                       )),
                            //                 ),
                            //             ]
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   }
                            // ),
                        ),
                      ),
                      Positioned(
                        width: MediaQuery.sizeOf(context).width * 0.97,

                        bottom: 8,
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
                                  icon: Icon(Icons.home,
                                      size: 32)),
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
                              // IconButton(
                              //     onPressed: () => Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => ProfilePage(),
                              //         )),
                              //     icon: Icon(Icons.account_circle_rounded,
                              //         size: 32)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
