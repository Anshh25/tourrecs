import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class PlaceProvider extends ChangeNotifier{
  List<Map<String, dynamic>> _placeDetails = [];
  List<Map<String, dynamic>> get placeDetails => _placeDetails;

  Future<void> fetchPlaceDetails() async{
    try{
      QuerySnapshot querySnapshot =
          await  FirebaseFirestore.instance.collection('Places').get();

      _placeDetails = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      notifyListeners();

    }catch(e){
      print(e);
    }

  }


}