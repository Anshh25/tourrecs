import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../wishlistprovider.dart';
import '../wishlistprovider.dart';

class PopularDestinations extends StatefulWidget {
  final String id; // ID of city or place
  final String collection; // Collection name ('City' or 'Places')
  final String name; // Collection name ('City' or 'Places')

  // CommonPage({required this.id, required this.collection});
  const PopularDestinations(
      {super.key,
      required this.id,
      required this.collection,
      required this.name});

  @override
  State<PopularDestinations> createState() => _PopularDestinationsState();
}

class _PopularDestinationsState extends State<PopularDestinations> {
  late User? _currentUser;
  bool _isInWishlist = false;
  late Future<QuerySnapshot<Object?>> _futureData;
  final int rating = 4;
  final wishlistProvider = WishlistProvider();

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
    _getCurrentUser();
    wishlistProvider.wishlist;

    //_checkIfInWishlist();
  }

  Future<QuerySnapshot<Object?>> _fetchData() async {
    // Fetch data from Firestore based on ID and collection
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(widget.collection);
    QuerySnapshot querySnapshot =
        await collectionReference.where('id', isEqualTo: widget.id).get();

    return querySnapshot;
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // Future<void> _checkIfInWishlist() async {
  //   if (_currentUser == null) return;
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_currentUser!.uid)
  //       .collection('wishlist')
  //       .doc(widget.id)
  //       .get();
  //   setState(() {
  //     _isInWishlist = snapshot.exists;
  //   });
  // }
  //
  // Future<void> _addToWishlist(BuildContext context) async {
  //   if (_currentUser == null) return;
  //   final wishlistCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_currentUser!.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(widget.id).set({
  //       'placeId': widget.id,
  //       'placeName': widget.name, // Add placeName to the wishlist document
  //       // You can add more details if needed
  //     });
  //     setState(() {
  //       _isInWishlist = true;
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Added to wishlist')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to add to wishlist')));
  //   }
  // }
  //
  // Future<void> _removeFromWishlist(BuildContext context) async {
  //   if (_currentUser == null) return;
  //   final wishlistCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_currentUser!.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(widget.id).delete();
  //     setState(() {
  //       _isInWishlist = false;
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Removed from wishlist')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to remove from wishlist')));
  //   }
  // }
  Future<void> _checkIfInWishlist() async {
    // Fetch the current user from authentication
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('wishlist')
        .doc(widget.id)
        .get();

    setState(() {
      _isInWishlist = snapshot.exists;
    });
  }

  // Future<void> _addToWishlist(BuildContext context) async {
  //   // Fetch the current user from authentication
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   final wishlistCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(widget.id).set({
  //       'placeId': widget.id,
  //       'placeName': widget.name, // Add placeName to the wishlist document
  //       // You can add more details if needed
  //     });
  //     setState(() {
  //       _isInWishlist = true;
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Added to wishlist')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Failed to add to wishlist')));
  //   }
  // }

  // Future<void> _removeFromWishlist(BuildContext context) async {
  //   // Fetch the current user from authentication
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   final wishlistCollection = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(widget.id).delete();
  //     setState(() {
  //       _isInWishlist = false;
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Removed from wishlist')));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to remove from wishlist')));
  //   }
  // }


  @override
  Widget build(BuildContext context) {
  // final wishlistProvider = Provider.of<WishlistProvider>(context);
  //  wishlistProvider.wishlist;
  //  final isInWishlist = wishlistProvider.isInWishlist(widget.id);
    return Scaffold(
      backgroundColor: Colors.white,
      // body: FutureBuilder(future: _futureData,builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //   if (snapshot.connectionState == ConnectionState.waiting) {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   }
      //   if (snapshot.hasError) {
      //     return Center(
      //       child: Text('Error: ${snapshot.error}'),
      //     );
      //   }
      //   if (!snapshot.hasData || !snapshot.data!.exists) {
      //     return Center(
      //       child: Text('Data not found'),
      //     );
      //   }
      //   var data = snapshot.data!.data() as Map<String, dynamic>;
      //
      //   return ListView(
      //     children: [
      //       Container(
      //         child: Column(
      //           children: [
      //             Stack(
      //               children: [
      //                 Image.network(
      //                   "${data['image']}",
      //                   height: 350,
      //                   width: MediaQuery.of(context).size.width,
      //                   fit: BoxFit.cover,
      //                 ),
      //                 Container(
      //                   height: 350,
      //                   color: Colors.black12,
      //                   padding: EdgeInsets.only(top: 50),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Container(
      //                         padding: EdgeInsets.only(
      //                           left: 24,
      //                           right: 24,
      //                         ),
      //                         child: Row(
      //                           children: [
      //                             GestureDetector(
      //                               onTap: () {
      //                                 Navigator.pop(context);
      //                               },
      //                               child: Container(
      //                                 child: Icon(
      //                                   Icons.arrow_back,
      //                                   color: Colors.white,
      //                                   size: 24,
      //                                 ),
      //                               ),
      //                             ),
      //                             Spacer(),
      //                             // Icon(
      //                             //   Icons.share,
      //                             //   color: Colors.white,
      //                             //   size: 24,
      //                             // ),
      //                             SizedBox(
      //                               width: 24,
      //                             ),
      //                             Image.asset(
      //                               "assets/heart.png",
      //                               height: 24,
      //                               width: 24,
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       Spacer(),
      //                       Container(
      //                         padding: EdgeInsets.only(
      //                           left: 24,
      //                           right: 24,
      //                         ),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //
      //                             SizedBox(
      //                               height: 12,
      //                             ),
      //                             Row(
      //                               children: [
      //                                 Icon(
      //                                   Icons.location_on,
      //                                   color: Colors.white70,
      //                                   size: 25,
      //                                 ),
      //                                 Text(
      //                                   "${data['name']}",
      //                                   style: TextStyle(
      //                                       color: Colors.white,
      //                                       fontWeight: FontWeight.w600,
      //                                       fontSize: 23),
      //                                 ),
      //                                 SizedBox(
      //                                   width: 8,
      //                                 ),
      //                                 // Text(
      //                                 //   "Bandra, Mumbai",
      //                                 //   style: TextStyle(
      //                                 //       color: Colors.white70,
      //                                 //       fontWeight: FontWeight.w500,
      //                                 //       fontSize: 17),
      //                                 // ),
      //                               ],
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             Row(
      //                               crossAxisAlignment: CrossAxisAlignment.center,
      //                               children: [
      //                                 Container(
      //                                     child: Row(
      //                                       crossAxisAlignment:
      //                                       CrossAxisAlignment.center,
      //                                       children: [
      //                                         Icon(
      //                                           Icons.star,
      //                                           color: rating >= 1
      //                                               ? Colors.white70
      //                                               : Colors.white30,
      //                                         ),
      //                                         SizedBox(
      //                                           width: 3,
      //                                         ),
      //                                         Icon(
      //                                           Icons.star,
      //                                           color: rating >= 2
      //                                               ? Colors.white70
      //                                               : Colors.white30,
      //                                         ),
      //                                         SizedBox(
      //                                           width: 3,
      //                                         ),
      //                                         Icon(
      //                                           Icons.star,
      //                                           color: rating >= 3
      //                                               ? Colors.white70
      //                                               : Colors.white30,
      //                                         ),
      //                                         SizedBox(
      //                                           width: 3,
      //                                         ),
      //                                         Icon(
      //                                           Icons.star,
      //                                           color: rating >= 4
      //                                               ? Colors.white70
      //                                               : Colors.white30,
      //                                         ),
      //                                         SizedBox(
      //                                           width: 3,
      //                                         ),
      //                                         Icon(
      //                                           Icons.star,
      //                                           color: rating >= 5
      //                                               ? Colors.white70
      //                                               : Colors.white30,
      //                                         ),
      //                                       ],
      //                                     )),
      //                                 SizedBox(
      //                                   width: 8,
      //                                 ),
      //                                 Text(
      //                                   "${data['rating']}",
      //                                   style: TextStyle(
      //                                       color: Colors.white70,
      //                                       fontWeight: FontWeight.w600,
      //                                       fontSize: 17),
      //                                 )
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 18,
      //                       ),
      //                       Container(
      //                         width: MediaQuery.of(context).size.width,
      //                         decoration: BoxDecoration(
      //                             color: Colors.white,
      //                             borderRadius: BorderRadius.only(
      //                                 topLeft: Radius.circular(30),
      //                                 topRight: Radius.circular(30))),
      //                         height: 50,
      //                       )
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 Opacity(
      //                   opacity: 0.7,
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           padding: EdgeInsets.all(8),
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Color(0xff5A6C64).withOpacity(0.5)),
      //                               borderRadius: BorderRadius.circular(40)),
      //                           child: Icon(Icons.wifi, color: Color(0xff5A6C64)),
      //                         ),
      //                         SizedBox(
      //                           height: 9,
      //                         ),
      //                         Container(
      //                             width: 70,
      //                             child: Text(
      //                               "Free Wi-Fi",
      //                               textAlign: TextAlign.center,
      //                               style: TextStyle(
      //                                   fontSize: 14,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: Color(0xff5A6C64)),
      //                             ))
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Opacity(
      //                   opacity: 0.7,
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           padding: EdgeInsets.all(8),
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Color(0xff5A6C64).withOpacity(0.5)),
      //                               borderRadius: BorderRadius.circular(40)),
      //                           child: Icon(Icons.beach_access,
      //                               color: Color(0xff5A6C64)),
      //                         ),
      //                         SizedBox(
      //                           height: 9,
      //                         ),
      //                         Container(
      //                             width: 70,
      //                             child: Text(
      //                               "Beach",
      //                               textAlign: TextAlign.center,
      //                               style: TextStyle(
      //                                   fontSize: 14,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: Color(0xff5A6C64)),
      //                             ))
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Opacity(
      //                   opacity: 0.7,
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           padding: EdgeInsets.all(8),
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Color(0xff5A6C64).withOpacity(0.5)),
      //                               borderRadius: BorderRadius.circular(40)),
      //                           child: Icon(Icons.card_travel,
      //                               color: Color(0xff5A6C64)),
      //                         ),
      //                         SizedBox(
      //                           height: 9,
      //                         ),
      //                         Container(
      //                             width: 70,
      //                             child: Text(
      //                               "Coastline",
      //                               textAlign: TextAlign.center,
      //                               style: TextStyle(
      //                                   fontSize: 14,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: Color(0xff5A6C64)),
      //                             ))
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Opacity(
      //                   opacity: 0.7,
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Container(
      //                           padding: EdgeInsets.all(8),
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Color(0xff5A6C64).withOpacity(0.5)),
      //                               borderRadius: BorderRadius.circular(40)),
      //                           child: Icon(Icons.local_drink,
      //                               color: Color(0xff5A6C64)),
      //                         ),
      //                         SizedBox(
      //                           height: 9,
      //                         ),
      //                         Container(
      //                             width: 70,
      //                             child: Text(
      //                               "Resturants",
      //                               textAlign: TextAlign.center,
      //                               style: TextStyle(
      //                                   fontSize: 14,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: Color(0xff5A6C64)),
      //                             ))
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Container(
      //               margin: EdgeInsets.symmetric(vertical: 24),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Container(
      //                     padding:
      //                     EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //                     decoration: BoxDecoration(
      //                         color: Color(0xffE9F4F9),
      //                         borderRadius: BorderRadius.circular(16)),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             Container(
      //                               padding: EdgeInsets.all(8),
      //                               decoration: BoxDecoration(
      //                                   color: Color(0xffD5E6F2),
      //                                   borderRadius: BorderRadius.circular(10)),
      //                               child: Image.asset(
      //                                 "assets/card1.png",
      //                                 height: 30,
      //                               ),
      //                             ),
      //                             SizedBox(
      //                               width: 8,
      //                             ),
      //                             Column(
      //                               crossAxisAlignment: CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   "Booking",
      //                                   textAlign: TextAlign.center,
      //                                   style: TextStyle(
      //                                       fontSize: 16,
      //                                       fontWeight: FontWeight.w600,
      //                                       color: Color(0xff5A6C64)),
      //                                 ),
      //                                 SizedBox(
      //                                   height: 6,
      //                                 ),
      //                                 Text(
      //                                   "8.0/10",
      //                                   textAlign: TextAlign.center,
      //                                   style: TextStyle(
      //                                       fontSize: 14,
      //                                       fontWeight: FontWeight.w600,
      //                                       color: Color(0xff5A6C64)),
      //                                 )
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                         SizedBox(
      //                           height: 8,
      //                         ),
      //                         Text(
      //                           " Based on 30 reviews",
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.w600,
      //                               color: Color(0xff879D95)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Container(
      //                     padding:
      //                     EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //                     decoration: BoxDecoration(
      //                         color: Color(0xffE9F4F9),
      //                         borderRadius: BorderRadius.circular(16)),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             Container(
      //                               padding: EdgeInsets.all(8),
      //                               decoration: BoxDecoration(
      //                                   color: Color(0xffD5E6F2),
      //                                   borderRadius: BorderRadius.circular(10)),
      //                               child: Image.asset(
      //                                 "assets/card2.png",
      //                                 height: 30,
      //                               ),
      //                             ),
      //                             SizedBox(
      //                               width: 8,
      //                             ),
      //                             Column(
      //                               crossAxisAlignment: CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   "MakeMyTrip",
      //                                   textAlign: TextAlign.center,
      //                                   style: TextStyle(
      //                                       fontSize: 16,
      //                                       fontWeight: FontWeight.w600,
      //                                       color: Color(0xff5A6C64)),
      //                                 ),
      //                                 SizedBox(
      //                                   height: 6,
      //                                 ),
      //                                 Text(
      //                                   "9.0/10",
      //                                   textAlign: TextAlign.center,
      //                                   style: TextStyle(
      //                                       fontSize: 14,
      //                                       fontWeight: FontWeight.w600,
      //                                       color: Color(0xff5A6C64)),
      //                                 )
      //                               ],
      //                             )
      //                           ],
      //                         ),
      //                         SizedBox(
      //                           height: 8,
      //                         ),
      //                         Text(
      //                           " Based on 45 reviews",
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.w600,
      //                               color: Color(0xff879D95)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 8,
      //             ),
      //             Container(
      //               padding: EdgeInsets.symmetric(horizontal: 24),
      //               child: Text(
      //                 "Mumbai (formerly called Bombay) is a densely populated city on India’s west coast. A financial center, it's India's largest city. On the Mumbai Harbour waterfront stands the iconic Gateway of India stone arch, built by the British Raj in 1924. Offshore, nearby Elephanta Island holds ancient cave temples dedicated to the Hindu god Shiva. The city's also famous as the heart of the Bollywood film industry.",
      //                 textAlign: TextAlign.start,
      //                 style: TextStyle(
      //                     fontSize: 15,
      //                     height: 1.5,
      //                     fontWeight: FontWeight.w600,
      //                     color: Color(0xff879D95)),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 16,
      //             ),
      //             // Container(
      //             //   height: 240,
      //             //   child: ListView.builder(
      //             //       padding: EdgeInsets.symmetric(horizontal: 24),
      //             //       itemCount: 3,
      //             //       shrinkWrap: true,
      //             //       physics: ClampingScrollPhysics(),
      //             //       scrollDirection: Axis.horizontal,
      //             //       itemBuilder: (context, index) {
      //             //         return Container(
      //             //           margin: EdgeInsets.only(right: 8),
      //             //           child: ClipRRect(
      //             //             borderRadius: BorderRadius.circular(16),
      //             //             child: CachedNetworkImage(
      //             //               imageUrl: "https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      //             //               height: 220,
      //             //               width: 150,
      //             //               fit: BoxFit.cover,
      //             //             ),
      //             //           ),
      //             //         );
      //             //       }),
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   );
      //
      // },),
      //

      body: StreamBuilder(

        // stream: FirebaseFirestore.instance.collection("City").where("id",isEqualTo: widget.id).snapshots(),
        stream: _futureData.asStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          // Check if the query snapshot has no data
          if (snapshot.data!.docs.isEmpty) {
            // return Center(
            //   child: Text('No Place found'),
            // );
            return Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        opacity: 230,
                        image: AssetImage("assets/images/1976998-1.jpg"),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Text('No Place found'),
                ));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              Future<void> _loadImage() async {
                final Completer<void> completer = Completer<void>();
                final image = NetworkImage(
                  "${data['image']}",
                );
                image.resolve(const ImageConfiguration()).addListener(
                  ImageStreamListener((info, _) {
                    completer.complete();
                  }),
                );
                return completer.future;
              }

              return Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: FutureBuilder<void>(
                            future: _loadImage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error loading image'));
                              } else {
                                return Image.network(
                                  "${data['image']}",
                                  height: 350,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                );
                              }
                            },
                          ),
                        ),
                        // Image.network(
                        //   "${data['image']}",
                        //   height: 350,
                        //   width: MediaQuery.of(context).size.width,
                        //   fit: BoxFit.cover,
                        // ),
                        Container(
                          height: 350,
                          color: Colors.black12,
                          padding: EdgeInsets.only(top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    // Icon(
                                    //   Icons.share,
                                    //   color: Colors.white,
                                    //   size: 24,
                                    // ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Consumer<WishlistProvider>(builder: (context, WishlistProvider, child) {
                                     // final wishlistProvider = Provider.of<WishlistProvider>(context);
                                      //wishlistProvider.wishlist;
                                      
                                      final isInWishlist = WishlistProvider.isInWishlist(widget.id);

                                      return  IconButton(
                                        icon: Icon(Icons.favorite),
                                        color:  isInWishlist ? Colors.red : Colors.white,
                                        onPressed: () async{
                                          if (WishlistProvider.isInWishlist(widget.id)) {
                                            WishlistProvider.removeFromWishlist(widget.id,widget.name);
                                            print("removed ${WishlistProvider.wishlist}");
                                          } else {
                                            WishlistProvider.addToWishlist(widget.id,widget.name);
                                            print("added ${WishlistProvider.wishlist}");

                                          }
                                        },
                                      );

                                    },),

                                    // IconButton(
                                    //   icon: Icon(_isInWishlist
                                    //       ? Icons.favorite
                                    //       : Icons.favorite_border),
                                    //   onPressed: () async{
                                    //     if (_isInWishlist) {
                                    //       final currentUser = FirebaseAuth.instance.currentUser;
                                    //       if (currentUser == null) return;
                                    //
                                    //       final wishlistCollection = FirebaseFirestore.instance
                                    //           .collection('users')
                                    //           .doc(currentUser.uid)
                                    //           .collection('wishlist');
                                    //
                                    //       try {
                                    //         await wishlistCollection.doc(widget.id).delete();
                                    //         setState(() {
                                    //           _isInWishlist = false;
                                    //         });
                                    //         ScaffoldMessenger.of(context)
                                    //             .showSnackBar(SnackBar(content: Text('Removed from wishlist')));
                                    //       } catch (error) {
                                    //         ScaffoldMessenger.of(context).showSnackBar(
                                    //             SnackBar(content: Text('Failed to remove from wishlist')));
                                    //       }
                                    //      // _removeFromWishlist(context);
                                    //     } else {
                                    //       final currentUser = FirebaseAuth.instance.currentUser;
                                    //       if (currentUser == null) return;
                                    //
                                    //       final wishlistCollection = FirebaseFirestore.instance
                                    //           .collection('users')
                                    //           .doc(currentUser.uid)
                                    //           .collection('wishlist');
                                    //
                                    //       try {
                                    //         await wishlistCollection.doc(widget.id).set({
                                    //           'placeId': widget.id,
                                    //           'placeName': widget.name, // Add placeName to the wishlist document
                                    //           // You can add more details if needed
                                    //         });
                                    //         setState(() {
                                    //           _isInWishlist = true;
                                    //         });
                                    //         ScaffoldMessenger.of(context)
                                    //             .showSnackBar(SnackBar(content: Text('Added to wishlist')));
                                    //       } catch (error) {
                                    //         ScaffoldMessenger.of(context)
                                    //             .showSnackBar(SnackBar(content: Text('Failed to add to wishlist')));
                                    //       }
                                    //      // _addToWishlist(context);
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white70,
                                          size: 25,
                                        ),
                                        Text(
                                          "${data['name']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 23),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        // Text(
                                        //   "Bandra, Mumbai",
                                        //   style: TextStyle(
                                        //       color: Colors.white70,
                                        //       fontWeight: FontWeight.w500,
                                        //       fontSize: 17),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // Row(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   children: [
                                    //     Container(
                                    //         child: Row(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         Icon(
                                    //           Icons.star,
                                    //           color: rating >= 1
                                    //               ? Colors.white70
                                    //               : Colors.white30,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 3,
                                    //         ),
                                    //         Icon(
                                    //           Icons.star,
                                    //           color: rating >= 2
                                    //               ? Colors.white70
                                    //               : Colors.white30,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 3,
                                    //         ),
                                    //         Icon(
                                    //           Icons.star,
                                    //           color: rating >= 3
                                    //               ? Colors.white70
                                    //               : Colors.white30,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 3,
                                    //         ),
                                    //         Icon(
                                    //           Icons.star,
                                    //           color: rating >= 4
                                    //               ? Colors.white70
                                    //               : Colors.white30,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 3,
                                    //         ),
                                    //         Icon(
                                    //           Icons.star,
                                    //           color: rating >= 5
                                    //               ? Colors.white70
                                    //               : Colors.white30,
                                    //         ),
                                    //       ],
                                    //     )),
                                    //     SizedBox(
                                    //       width: 8,
                                    //     ),
                                    //     Text(
                                    //       "${data['rating']}",
                                    //       style: TextStyle(
                                    //           color: Colors.white70,
                                    //           fontWeight: FontWeight.w600,
                                    //           fontSize: 17),
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                height: 50,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Opacity(
                    //       opacity: 0.7,
                    //       child: Container(
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(8),
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       color: Color(0xff5A6C64)
                    //                           .withOpacity(0.5)),
                    //                   borderRadius: BorderRadius.circular(40)),
                    //               child: Icon(Icons.wifi,
                    //                   color: Color(0xff5A6C64)),
                    //             ),
                    //             SizedBox(
                    //               height: 9,
                    //             ),
                    //             Container(
                    //                 width: 70,
                    //                 child: Text(
                    //                   "Free Wi-Fi",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Color(0xff5A6C64)),
                    //                 ))
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Opacity(
                    //       opacity: 0.7,
                    //       child: Container(
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(8),
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       color: Color(0xff5A6C64)
                    //                           .withOpacity(0.5)),
                    //                   borderRadius: BorderRadius.circular(40)),
                    //               child: Icon(Icons.beach_access,
                    //                   color: Color(0xff5A6C64)),
                    //             ),
                    //             SizedBox(
                    //               height: 9,
                    //             ),
                    //             Container(
                    //                 width: 70,
                    //                 child: Text(
                    //                   "Beach",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Color(0xff5A6C64)),
                    //                 ))
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Opacity(
                    //       opacity: 0.7,
                    //       child: Container(
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(8),
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       color: Color(0xff5A6C64)
                    //                           .withOpacity(0.5)),
                    //                   borderRadius: BorderRadius.circular(40)),
                    //               child: Icon(Icons.card_travel,
                    //                   color: Color(0xff5A6C64)),
                    //             ),
                    //             SizedBox(
                    //               height: 9,
                    //             ),
                    //             Container(
                    //                 width: 70,
                    //                 child: Text(
                    //                   "Coastline",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Color(0xff5A6C64)),
                    //                 ))
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Opacity(
                    //       opacity: 0.7,
                    //       child: Container(
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(8),
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       color: Color(0xff5A6C64)
                    //                           .withOpacity(0.5)),
                    //                   borderRadius: BorderRadius.circular(40)),
                    //               child: Icon(Icons.local_drink,
                    //                   color: Color(0xff5A6C64)),
                    //             ),
                    //             SizedBox(
                    //               height: 9,
                    //             ),
                    //             Container(
                    //                 width: 70,
                    //                 child: Text(
                    //                   "Resturants",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: Color(0xff5A6C64)),
                    //                 ))
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 24),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 16, vertical: 8),
                    //         decoration: BoxDecoration(
                    //             color: Color(0xffE9F4F9),
                    //             borderRadius: BorderRadius.circular(16)),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Container(
                    //                   padding: EdgeInsets.all(8),
                    //                   decoration: BoxDecoration(
                    //                       color: Color(0xffD5E6F2),
                    //                       borderRadius:
                    //                           BorderRadius.circular(10)),
                    //                   child: Image.asset(
                    //                     "assets/card1.png",
                    //                     height: 30,
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 8,
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "Booking",
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Color(0xff5A6C64)),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Text(
                    //                       "8.0/10",
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Color(0xff5A6C64)),
                    //                     )
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 8,
                    //             ),
                    //             Text(
                    //               " Based on 30 reviews",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: Color(0xff879D95)),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Container(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 16, vertical: 8),
                    //         decoration: BoxDecoration(
                    //             color: Color(0xffE9F4F9),
                    //             borderRadius: BorderRadius.circular(16)),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Container(
                    //                   padding: EdgeInsets.all(8),
                    //                   decoration: BoxDecoration(
                    //                       color: Color(0xffD5E6F2),
                    //                       borderRadius:
                    //                           BorderRadius.circular(10)),
                    //                   child: Image.asset(
                    //                     "assets/card2.png",
                    //                     height: 30,
                    //                   ),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 8,
                    //                 ),
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       "MakeMyTrip",
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                           fontSize: 16,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Color(0xff5A6C64)),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 6,
                    //                     ),
                    //                     Text(
                    //                       "9.0/10",
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.w600,
                    //                           color: Color(0xff5A6C64)),
                    //                     )
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 8,
                    //             ),
                    //             Text(
                    //               " Based on 45 reviews",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: Color(0xff879D95)),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "${data['description']}",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff879D95)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Container(
                    //   height: 240,
                    //   child: ListView.builder(
                    //       padding: EdgeInsets.symmetric(horizontal: 24),
                    //       itemCount: 3,
                    //       shrinkWrap: true,
                    //       physics: ClampingScrollPhysics(),
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return Container(
                    //           margin: EdgeInsets.only(right: 8),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(16),
                    //             child: CachedNetworkImage(
                    //               imageUrl: "https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                    //               height: 220,
                    //               width: 150,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyImageWithProgressIndicator extends StatelessWidget {
  final String imageUrl;

  MyImageWithProgressIndicator({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading image'));
          } else {
            return Image.network(
              imageUrl,
              height: 350,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            );
          }
        },
      ),
    );
  }

  Future<void> _loadImage() async {
    final Completer<void> completer = Completer<void>();
    final image = NetworkImage(imageUrl);
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete();
      }),
    );
    return completer.future;
  }
}

class FeaturesTile extends StatelessWidget {
  final Icon icon;
  final String label;

  FeaturesTile({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5A6C64).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(40)),
              child: Icon(Icons.wifi, color: Color(0xff5A6C64)),
            ),
            SizedBox(
              height: 9,
            ),
            Container(
                width: 70,
                child: Text(
                  "Free Wi-Fi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5A6C64)),
                ))
          ],
        ),
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Color(0xffE9F4F9), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xffD5E6F2),
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/card1.png",
                  height: 30,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booking",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5A6C64)),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "8.0/10",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff5A6C64)),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            " Based on 30 reviews",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff879D95)),
          ),
        ],
      ),
    );
  }
}
