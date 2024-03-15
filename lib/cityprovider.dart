

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class CityProvider with ChangeNotifier {
  List<Map<String, dynamic>> cityDetailss = [];
  List<Map<String, dynamic>> get cityDetails => cityDetailss;

  Future<void> fetchCityDetails() async {
    print("fetchCityDetails 1");
    try {

      await FirebaseFirestore.instance.collection('City').get().then((value) {
        cityDetailss =   value.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
      });
      print("fetchCityDetails 2");
      // _cityDetails = await querySnapshot.docs
      //     .map((doc) => doc.data() as Map<String, dynamic>)
      //     .toList();
      print("fetchCityDetails3 ${cityDetailss.length}" );
   //   print('Fetched city details: $_cityDetails');
     // print('Fetched city details: $cityDetails');

      notifyListeners();
    } catch (e) {
      print(e);
    }

  }

}
// class CityProvider extends ChangeNotifier{
//   List<Map<String, dynamic>> cityDetails = [];
//
//   List<Map<String, dynamic>> get CityDetails => cityDetails;
//
//   Future<void> fetchCityDetails() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('City').get();
//       cityDetails = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }
// // List<DocumentSnapshot> cityDetails = [];
// //
// // List<DocumentSnapshot> get CityDetails => cityDetails;
// //
// // Future<void> fetchCityDetails() async {
// //   try {
// //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('City').get();
// //     List<DocumentSnapshot> fetchedCityDetails = querySnapshot.docs;
// //     print('Fetched city details: $fetchedCityDetails');
// //     cityDetails = fetchedCityDetails;
// //     print('Fetched city details: $cityDetails');
// //
// //     notifyListeners();
// //   } catch (e) {
// //     print('Error fetching city details: $e');
// //   }
// }

// Future<void> fetchCityDetails() async{
//   try{
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('City').get();
//     print('Fetched city details: $cityDetails');
//
//     cityDetails = querySnapshot.docs;
//     print('Fetched city details: $cityDetails');
//     notifyListeners();
//   }catch(e){
//       print(e);
//
//   }
// }

