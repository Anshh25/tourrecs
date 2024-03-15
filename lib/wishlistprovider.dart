

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class WishlistProvider extends ChangeNotifier{
  bool _isInWishlist = false;
 // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 // final currentUser = FirebaseAuth.instance.currentUser!;

  List<String> _wishlist = [];
  List<String> get wishlist => _wishlist;

  // Fetch wishlist from Firestore
  Future<void> fetchWishlist() async {
    final FirebaseFirestore _firestore = await FirebaseFirestore.instance;
    final currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('wishlist')
        .get();

    _wishlist = snapshot.docs.map<String>((doc) => doc['placeId'] as String).toList();

    notifyListeners();
  }

  // Check if a place exists in the wishlist
  bool isInWishlist(String placeId) {
    return _wishlist.contains(placeId);


  } notifyListeners();

void addToWishlist(String placeId, String placeName) async{
  final FirebaseFirestore _firestore = await FirebaseFirestore.instance;
  final currentUser = await FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final wishlistCollection = _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('wishlist');
  try {
    await wishlistCollection.doc(placeId).set({
      'placeId': placeId,
      'placeName': placeName,
    });
    notifyListeners();
  } catch (error) {
    print('Failed to add to wishlist: $error');
  }


  _wishlist.add(placeId);
  _wishlist.add(placeName);
  notifyListeners();
}

void removeFromWishlist(String placeId, String placeName)async{
  final FirebaseFirestore _firestore = await FirebaseFirestore.instance;
  final currentUser = await FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final wishlistCollection = _firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('wishlist');

  try {
    await wishlistCollection.doc(placeId).delete();
  } catch (error) {
    print('Failed to remove from wishlist: $error');
  }


  _wishlist.remove(placeId);
  _wishlist.remove(placeName);
  notifyListeners();
}

  // Future<void> _checkIfInWishlist() async {
  //   // Fetch the current user from authentication
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist')
  //       .doc(widget.id)
  //       .get();
  //
  //
  // }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  // Future<void> addToWishlist(String placeId, String placeName) async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   final wishlistCollection = _firestore
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(placeId).set({
  //       'placeId': placeId,
  //       'placeName': placeName,
  //     });
  //     notifyListeners();
  //   } catch (error) {
  //     print('Failed to add to wishlist: $error');
  //   }
  // }
  //
  // Future<void> removeFromWishlist(String placeId) async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;
  //
  //   final wishlistCollection = _firestore
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist');
  //
  //   try {
  //     await wishlistCollection.doc(placeId).delete();
  //     notifyListeners();
  //   } catch (error) {
  //     print('Failed to remove from wishlist: $error');
  //   }
  // }
  //
  // Future<bool> isInWishlist(String placeId) async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return false;
  //
  //   final wishlistCollection = _firestore
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('wishlist');
  //
  //   final snapshot = await wishlistCollection.doc(placeId).get();
  //   return snapshot.exists;
  // }
}


