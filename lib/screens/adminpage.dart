import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourrecs/screens/citytable.dart';
import 'package:tourrecs/screens/placetable.dart';
import 'package:tourrecs/screens/signin.dart';
import 'package:tourrecs/screens/usertable.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // List city = ['Mumbai','Ahmedabad','Surat','Delhi','Navsari','ShriNagar','Pune','Banglore','Baroda','Rajkot'];
  List city = [];
  TextEditingController _addcity = TextEditingController();
  TextEditingController _updatecity = TextEditingController();

  addcityfirebase(city) {
    try {
      FirebaseFirestore.instance.collection("City").add({"city": city});
      print('city added to Firestore successfully');
    } catch (e) {
      print('Error adding city to Firestore: $e');
    }
  }
  updatecityfirebase(city,i) async {
    try {
      // FirebaseFirestore.instance.collection("City").doc().update({
      //   "city": city
      // });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("City")
          .where('city', isEqualTo: i)
          .get();

      print("iiiii:$i");
      // Iterate over the documents and update the desired field
      querySnapshot.docs.forEach((doc) async {
        // Get the document reference
        DocumentReference docRef =
            FirebaseFirestore.instance.collection("City").doc(doc.id);

        // Update the document with the given data
        await docRef.update({"city": city});
        print("updatecityyyy: ${city}");
        getcityfirebase();
      });
      print('city update to Firestore successfully');
    } catch (e) {
      print('Error city update to Firestore: $e');
    }
  }
  deletecityfirebase(i) async {
    try {
      // FirebaseFirestore.instance.collection("City").doc().update({
      //   "city": city
      // });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("City")
          .where('city', isEqualTo: i)
          .get();

      print("iiiii:$i");
      // Iterate over the documents and update the desired field
      querySnapshot.docs.forEach((doc) async {
        // Get the document reference
        DocumentReference docRef =
            FirebaseFirestore.instance.collection("City").doc(doc.id);

        // Update the document with the given data
        await docRef.delete();
        print("deletecityyyy: ${city}");
        getcityfirebase();
      });
      print('city delete from Firestore successfully');
    } catch (e) {
      print('Error city delete from Firestore: $e');
    }
  }
  getcityfirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("City").where('city').get();

    // Process the query snapshot
    city.clear();
    querySnapshot.docs.forEach((doc) {
      print('City: ${doc['city']}');

      setState(() {
        city.add(doc['city']);
      });

      // Access data in each document
      print('cityyyylist: ${city}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcityfirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                  ),
                  // ElevatedButton(onPressed: () {
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage(),));
                  //
                  // }, child: Text("Logout")),
                  Align(alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      width: MediaQuery.sizeOf(context).width * 0.59,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)]),
                      child: Center(
                        child: Text(
                          "Dashboard",
                          style: GoogleFonts.poppins(
                              fontSize: 32, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                  ),
                  Text("Database Collections :", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => City(),));
                  },
                    child: Card(

                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 70,
                        width: MediaQuery.sizeOf(context).width*0.9,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("City ",style: TextStyle( fontSize: 24,fontWeight: FontWeight.w600),),
                            Icon(Icons.location_city, color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Place(),));
                  },
                    child: Card(
                      elevation: 5,

                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 70,
                        width: MediaQuery.sizeOf(context).width*0.9,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Places ",style: TextStyle( fontSize: 24,fontWeight: FontWeight.w600),),
                            Icon(Icons.place, color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Users(),));
                  },
                    child: Card(
                      elevation: 5,

                      child: Container(
                        height: 70,
                        padding: EdgeInsets.only(left: 20),
                        width: MediaQuery.sizeOf(context).width*0.9,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Users ",style: TextStyle( fontSize: 24,fontWeight: FontWeight.w600),),
                            Icon(Icons.verified_user, color: Colors.black,)
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center(
                  //   child: Container(
                  //     //color: Colors.blue,
                  //     height: MediaQuery.sizeOf(context).height * 0.626,
                  //     width: MediaQuery.sizeOf(context).width * 0.99,
                  //     child: (city.isEmpty)
                  //         ? Center(
                  //             child: Text(
                  //             "No data added yet",
                  //             style: TextStyle(fontSize: 24),
                  //           ))
                  //         : ListView.builder(
                  //             itemCount: city.length,
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 height: 50,
                  //                 margin: EdgeInsets.all(5),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     boxShadow: [
                  //                       BoxShadow(color: Colors.grey, blurRadius: 5)
                  //                     ]),
                  //                 // child: Center(
                  //                 //     child: Text(
                  //                 //   "${city[index]}",
                  //                 //   style: TextStyle(fontSize: 24),
                  //                 // )),
                  //                 child: ListTile(
                  //                   leading: Text("${index + 1}"),
                  //                   title: Center(
                  //                       child: Text(
                  //                     "${city[index]}",
                  //                     style: TextStyle(fontSize: 24),
                  //                   )),
                  //                   trailing: Row(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       GestureDetector(
                  //                         //Add city
                  //                         onTap: () {
                  //                           print("city[index]lllll: ${city[index]}");
                  //                           showDialog(
                  //                             context: context,
                  //                             builder: (context) {
                  //                               return AlertDialog(
                  //                                 title: Text("Update City"),
                  //                                 content: Container(
                  //                                   height: 180,
                  //                                   child: Column(
                  //                                     children: [
                  //                                       TextField(
                  //                                         controller: _updatecity,
                  //                                       ),
                  //                                       SizedBox(
                  //                                         height: 30,
                  //                                       ),
                  //                                       ElevatedButton(
                  //                                           onPressed: () {
                  //                                             setState(() {
                  //                                               updatecityfirebase(_updatecity.text.toString(),city[index]);
                  //                                               // city.add(_addcity.text);
                  //                                               Navigator.pop(
                  //                                                   context);
                  //                                               //FirebaseFirestore.instance.collection('city').add('${_addcity.text}' as Map<String, dynamic>);
                  //                                             });
                  //                                             _updatecity.clear();
                  //                                           },
                  //                                           child: Text("Update"))
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               );
                  //                             },
                  //                           );
                  //                         },
                  //                         child: Icon(Icons.edit), //Add city
                  //                       ),
                  //                       SizedBox(width: 15,),
                  //                       GestureDetector(onTap: () async{
                  //                         await deletecityfirebase(city[index]);
                  //                       },child: Icon(Icons.delete))
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //   ),
                  // ),

                  // Container(
                  //   height: 200,
                  //   color: Colors.blue,
                  //
                  //   child: GridView.builder(itemCount: city.length,gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100),
                  //     itemBuilder: (context, index) {
                  //      return Container(
                  //        margin: EdgeInsets.all(10),
                  //        height: MediaQuery.sizeOf(context).height*0.12,
                  //        width: MediaQuery.sizeOf(context).width*0.25,
                  //        decoration: BoxDecoration(
                  //            color: Colors.black,
                  //            borderRadius: BorderRadius.circular(10)
                  //        ),
                  //        child: Center(child: Text("${city[index]}",style: TextStyle(color: Colors.white),)),
                  //      );
                  //     },
                  //
                  //   ),
                  // ),

                ],
              ),
              Positioned(bottom: 0,right: 0,
                child: GestureDetector(onTap: (){
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure to Sign Out?"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage(),));
                        }, child: Text("Yes", style: TextStyle(color: Colors.black)),),
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text("No", style: TextStyle(color: Colors.black)),),
                      ],
                    );
                  },);
                },
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    //padding: EdgeInsets.only(right: 50),79
                    height: 59,
                    width: 100,

                    decoration: BoxDecoration(


                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(child: Text("Sign Out", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
