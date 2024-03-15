import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class City extends StatefulWidget {
  const City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_updatecityname.text = citylist['cityname'];
    //updatecircleavatar();
    //citylist = [] as Map<String, dynamic>;




    getcityfirebase();
  }

  //late Map<String,dynamic> citylist ;
  List cityname = [];
  List description = [];
  List rating = [];

  //final storage = FirebaseStorage.instance;

  TextEditingController _addcity = TextEditingController();
  TextEditingController _citydescription = TextEditingController();
  TextEditingController _cityrating = TextEditingController();

  TextEditingController _updatecityname = TextEditingController();
  TextEditingController _updatecitydescription = TextEditingController();
  TextEditingController _updatecityrating = TextEditingController();

  // CollectionReference _reference=FirebaseFirestore.instance.collection('City');
  String imageUrl = '';

  ImagePicker _imagePicker = ImagePicker();
  File? image;
  //File? imagee;
  var imageTemp;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      //File imageFile = File(image.path);
      File imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
       // imagee = (image as File?)!;
      } );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    // if(image!=null){
    //   setState(() {
    //     imageTemp = image;
    //   });
    // }

  }

  addcitydetailsfirebase(name, rating,  cityimage) {
    DocumentReference docRef =
    FirebaseFirestore.instance.collection("City").doc();

    // Get the auto-generated ID
    String documentId = docRef.id;
    //String uniqueId = FirebaseFirestore.instance.collection("City").id;
    try {
      FirebaseFirestore.instance.collection("City").add({
        "id": documentId,
        "name": name,
        "rating": rating,
        //"description": description,
        "cityimage": cityimage
      });
      print('city added to Firestore successfully');
    } catch (e) {
      print('Error adding city to Firestore: $e');
    }
  }

  deletecitynamefirebase(i) async {
    try {
      // FirebaseFirestore.instance.collection("City").doc().update({
      //   "city": city
      // });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("City")
          .where('name', isEqualTo: i)
          .get();

      print("iiiii:$i");
      // Iterate over the documents and update the desired field
      querySnapshot.docs.forEach((doc) async {
        // Get the document reference
        DocumentReference docRef =
        FirebaseFirestore.instance.collection("City").doc(doc.id);

        // Update the document with the given data
        await docRef.delete();
        print("deletecityyyy: ${cityname}");
        getcityfirebase();
      });
      print('city name delete from Firestore successfully');
    } catch (e) {
      print('Error city name delete from Firestore: $e');
    }
  }

  // deletecitydescriptionfirebase(i) async {
  //   try {
  //     // FirebaseFirestore.instance.collection("City").doc().update({
  //     //   "city": city
  //     // });
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection("City")
  //         .where('description', isEqualTo: i)
  //         .get();
  //
  //     print("iiiii:$i");
  //     // Iterate over the documents and update the desired field
  //     querySnapshot.docs.forEach((doc) async {
  //       // Get the document reference
  //       DocumentReference docRef =
  //       FirebaseFirestore.instance.collection("City").doc(doc.id);
  //
  //       // Update the document with the given data
  //       await docRef.delete();
  //       print("deletecityyyy: ${description}");
  //       // getcitydescriptionfirebase();
  //     });
  //     print('city description delete from Firestore successfully');
  //   } catch (e) {
  //     print('Error city description delete from Firestore: $e');
  //   }
  // }

  deletecityratingfirebase(i) async {
    try {
      // FirebaseFirestore.instance.collection("City").doc().update({
      //   "city": city
      // });
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("City")
          .where('rating', isEqualTo: i)
          .get();

      print("iiiii:$i");
      // Iterate over the documents and update the desired field
      querySnapshot.docs.forEach((doc) async {
        // Get the document reference
        DocumentReference docRef =
        FirebaseFirestore.instance.collection("City").doc(doc.id);

        // Update the document with the given data
        await docRef.delete();
        print("deletecityyyy: ${rating}");
        //getcityratingfirebase();
      });
      print('city rating delete from Firestore successfully');
    } catch (e) {
      print('Error city rating delete from Firestore: $e');
    }
  }

  getcityfirebase() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("City").get();

    print("querySnapshot ${querySnapshot.docs.last.data()}");
    // Process the query snapshot
    cityname.clear();
    querySnapshot.docs.forEach((doc) {
      print('City: ${doc['name']}');

      setState(() {
        cityname.add(doc['name']);
       // description.add(doc['description']);
        rating.add(doc['rating']);
      });

      // Access data in each document
      print('cityyyylist: ${cityname}');
    });
  }



  @override
  Widget build(BuildContext context) {
    StateSetter _setState;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            "Cities",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Handle search icon button press
                showSearch(context: context, delegate: CitySearch());
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
                        _setState = setState;
                        return AlertDialog(
                            title: Text("Add City"),
                            content: SingleChildScrollView(
                              child: Container(
                                // height: 500,
                                width: MediaQuery
                                    .sizeOf(context)
                                    .width * 0.9,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        // CircleAvatar(
                                        //   maxRadius: 50,
                                        //   backgroundImage: Image.file(image!),
                                        // ),
                                        CircleAvatar(
                                          maxRadius: 70,
                                          backgroundImage: (image != null)? FileImage(image!) : null ,
                                        ),
                                        (image != null)
                                            ? CircleAvatar(
                                          backgroundImage:
                                          FileImage(image!),
                                          maxRadius: 70,
                                        )
                                            : CircleAvatar(
                                          // backgroundImage: ,
                                          maxRadius: 70,
                                        ),
                                        Positioned(
                                          child: IconButton(
                                              splashRadius: 23,
                                              onPressed: () async{
                                                await pickImage();
                                                setState((){});


                                              },
                                              icon: Icon(
                                                Icons.add_a_photo_rounded,
                                                size: 25,
                                                color: Colors.black,
                                              )),
                                          bottom: 0,
                                          right: -10,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText: "Name", labelText: "Name"),
                                      controller: _addcity,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Rating(1-10)",
                                          labelText: "Rating"),
                                      controller: _cityrating,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // TextField(
                                    //   maxLines: 5,
                                    //   decoration: InputDecoration(
                                    //     labelStyle:
                                    //     TextStyle(color: Colors.black),
                                    //     hintText: "Description",
                                    //     labelText: "Description",
                                    //   ),
                                    //   controller: _citydescription,
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStatePropertyAll(
                                              Colors.black),
                                        ),
                                        onPressed: () async {
                                          String imageFileName = DateTime
                                              .now()
                                              .millisecondsSinceEpoch
                                              .toString();
                                          Reference referenceRoot =
                                          FirebaseStorage.instance.ref();
                                          Reference referenceDirCityImages =
                                          referenceRoot.child('cityImages');
                                          Reference referenceImageToUpload =
                                          referenceDirCityImages
                                              .child(imageFileName);
                                          try {
                                            await referenceImageToUpload.putFile(
                                                File(image!.path),
                                                SettableMetadata(
                                                    contentType: 'image/jpeg'));
                                            imageUrl =
                                            await referenceImageToUpload
                                                .getDownloadURL();
                                          } catch (e) {
                                            print(e);
                                          }
                                          setState(() {
                                            // addcityfirebase(
                                            //     _addcity.text.toString());
                                            addcitydetailsfirebase(
                                                _addcity.text.toString(),
                                                _cityrating.text.toString(),
                                                // _citydescription.text.toString(),
                                                imageUrl.toString());


                                            Navigator.pop(context);
                                          });
                                          _addcity.clear();
                                          // _citydescription.clear();
                                          _cityrating.clear();
                                          //imageUrl= '';
                                        },
                                        child: Text("Add"))
                                  ],
                                ),
                              ),
                            ));
                      },);

                    },
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery
              .sizeOf(context)
              .height,
          width: MediaQuery
              .sizeOf(context)
              .width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 230,
                  image: AssetImage("assets/images/1976998-1.jpg"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Container(
              height: MediaQuery
                  .sizeOf(context)
                  .height,
              width: MediaQuery
                  .sizeOf(context)
                  .width * 0.99,
              child: (cityname.isEmpty)
                  ? Center(
                  child: Text(
                    "No data added yet",
                    style: TextStyle(fontSize: 24),
                  ))
                  : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('City')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                    return Center(
                      child: Text('No cities found'),
                    );
                  }

                  final cities = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // final city = cities[index];
                        final cityData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;




                        return Container(
                          height: 80,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey, blurRadius: 5)
                              ]),

                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${index + 1}"),
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "${cityData['cityimage']}"),
                                  maxRadius: 30,
                                )
                              ],
                            ),
                            title: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${cityData['name']}",
                                  style: TextStyle(fontSize: 24),
                                ),
                                // Text(
                                //   overflow: TextOverflow.ellipsis,
                                //   "Description : ${cityData['description']}",
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //   ),
                                // ),
                                Text(
                                  "Rating : ${cityData['rating']}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  //Update city
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (context) {

                                          return StatefulBuilder(builder: (BuildContext context,StateSetter setState) {
                                            _setState = setState;
                                            return AlertDialog(
                                                title: Text("Update City"),
                                                content:
                                                SingleChildScrollView(
                                                  child: Container(
                                                    // height: 500,
                                                    width: MediaQuery
                                                        .sizeOf(
                                                        context)
                                                        .width *
                                                        0.9,
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          children: [



                                                            //
                                                            // (image != null)
                                                            //     ?
                                                            CircleAvatar(
                                                              backgroundImage: (image != null)?
                                                              FileImage(image!): NetworkImage(
                                                                  "${cityData['cityimage']}") as ImageProvider<ImageProvider>,
                                                              maxRadius: 70,),
                                                            //  :CircleAvatar(
                                                            //   maxRadius: 70,
                                                            //   backgroundImage:
                                                            //   NetworkImage(
                                                            //       "${cityData['cityimage']}"),
                                                            // ),



                                                            Positioned(
                                                              child:
                                                              IconButton(
                                                                  splashRadius:
                                                                  23,
                                                                  onPressed:
                                                                      () async {
                                                                    await pickImage();
                                                                    setState(() {

                                                                    });

                                                                  },
                                                                  icon:
                                                                  Icon(
                                                                    Icons
                                                                        .add_a_photo_rounded,
                                                                    size:
                                                                    25,
                                                                    color:
                                                                    Colors
                                                                        .black,
                                                                  )),
                                                              bottom: 0,
                                                              right: -10,
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextField(
                                                          //initialValue: cityData['cityname'].toString(),



                                                          decoration:
                                                          InputDecoration(
                                                              hintText:
                                                              "Name",
                                                              labelText:
                                                              "Name"),
                                                          controller:

                                                          _updatecityname = TextEditingController(text: "${cityData!['name']}"),


                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                          decoration:
                                                          InputDecoration(
                                                              hintText:
                                                              "Rating(1-10)",
                                                              labelText:
                                                              "Rating"),
                                                          controller:
                                                          _updatecityrating = TextEditingController(text: "${cityData!['rating']}"),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        // TextField(
                                                        //   maxLines: 5,
                                                        //   decoration:
                                                        //   InputDecoration(
                                                        //     labelStyle: TextStyle(
                                                        //         color: Colors
                                                        //             .black),
                                                        //     hintText:
                                                        //     "Description",
                                                        //     labelText:
                                                        //     "Description",
                                                        //   ),
                                                        //   controller:
                                                        //   _updatecitydescription = TextEditingController(text: "${cityData!['description']}"),
                                                        // ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ElevatedButton(
                                                            style:
                                                            ButtonStyle(
                                                              backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors
                                                                      .black),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              String
                                                              imageFileName =
                                                              DateTime
                                                                  .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString();
                                                              Reference
                                                              referenceRoot =
                                                              FirebaseStorage
                                                                  .instance
                                                                  .ref();
                                                              Reference
                                                              referenceDirCityImages =
                                                              referenceRoot
                                                                  .child(
                                                                  'cityImages');
                                                              Reference
                                                              referenceImageToUpload =
                                                              referenceDirCityImages
                                                                  .child(
                                                                  imageFileName);
                                                              try {
                                                                await referenceImageToUpload
                                                                    .putFile(
                                                                    File(image!
                                                                        .path),
                                                                    SettableMetadata(
                                                                        contentType:
                                                                        'image/jpeg'));
                                                                imageUrl =
                                                                await referenceImageToUpload
                                                                    .getDownloadURL();
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                              showDialog(
                                                                  context:
                                                                  context,
                                                                  builder:
                                                                      (
                                                                      context) =>
                                                                      Center(
                                                                        child: CircularProgressIndicator(
                                                                          color: Colors
                                                                              .black,
                                                                        ),
                                                                      ));
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'City')
                                                                  .doc(
                                                                  snapshot.data!.docs[index].id)
                                                                  .update({
                                                                'name':
                                                                _updatecityname
                                                                    .text
                                                              });
                                                              // await FirebaseFirestore
                                                              //     .instance
                                                              //     .collection(
                                                              //     'City')
                                                              //     .doc(
                                                              //     snapshot.data!.docs[index].id)
                                                              //     .update({
                                                              //   'description':
                                                              //   _updatecitydescription
                                                              //       .text
                                                              // });
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'City')
                                                                  .doc(
                                                                  snapshot.data!.docs[index].id)
                                                                  .update({
                                                                'rating':
                                                                _updatecityrating
                                                                    .text
                                                              });
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                  'City')
                                                                  .doc(
                                                                  snapshot.data!.docs[index].id)
                                                                  .update({
                                                                'cityimage':
                                                                imageUrl
                                                              });
                                                              setState(() {

                                                              });
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();


                                                              setState(() {

                                                                getcityfirebase();

                                                                Navigator.of(
                                                                    context)
                                                                    .pop();

                                                              });

                                                            },
                                                            child: Text(
                                                                "Update"))
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },);
                                        },
                                      );
                                    });

                                  },
                                  child: Icon(Icons.edit), //Add city
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              Center(
                                                child:
                                                CircularProgressIndicator(
                                                  color: Colors.black,
                                                ),
                                              ));

                                      await deletecitynamefirebase(
                                          cityname[index]);
                                      // await deletecitydescriptionfirebase(
                                      //     description[index]);
                                      await deletecityratingfirebase(
                                          rating[index]);

                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.delete))
                              ],
                            ),
                          ),
                        );

                        ;
                      });
                },
              ),
            ),
          ),
        ));
  }
}

class CitySearch extends SearchDelegate<String>{

  final CollectionReference citiesRef =
  FirebaseFirestore.instance.collection('City');

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
    return FutureBuilder<QuerySnapshot>(
      future: citiesRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:  NetworkImage("${data['cityimage']}"),
                ),
                title: Text(data['name'], style: TextStyle(fontSize: 20),),
                onTap: () {
                  close(context, data['name']);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: citiesRef
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(5)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text(data['name']),
                onTap: () {
                  query = data['name'];
                  showResults(context);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// addcityfirebase(city) {
//   try {
//     FirebaseFirestore.instance.collection("City").add({"name": city});
//     print('city added to Firestore successfully');
//   } catch (e) {
//     print('Error adding city to Firestore: $e');
//   }
// }
// addcityphotofirebase(photo) {
//   try {
//     FirebaseFirestore.instance.collection("City").add({"photo": photo});
//     print('cityphoto added to Firestore successfully');
//   } catch (e) {
//     print('Error adding cityphoto to Firestore: $e');
//   }
// }

// addcitydecriptionfirebase(description) {
//   try {
//     FirebaseFirestore.instance.collection("City").add({"rating": description});
//     print('citydescription added to Firestore successfully');
//   } catch (e) {
//     print('Error adding citydescription to Firestore: $e');
//   }
// }
// updatecityfirebase(name, rating, description, i) async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("City")
//         .where('name', isEqualTo: i)
//         .where('rating', isEqualTo: i)
//         .where('description', isEqualTo: i)
//         .get();
//
//     print("iiiii:$i");
//     // Iterate over the documents and update the desired field
//     querySnapshot.docs.forEach((doc) async {
//       // Get the document reference
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection("City").doc(doc.id);
//
//       // Update the document with the given data
//       await docRef.update(
//           {"name": name, "rating": rating, "description": description});
//       // await docRef.update({"rating": rating});
//       // await docRef.update({"description": description});
//
//       getcityfirebase();
//       // getcitydescriptionfirebase();
//       //getcityratingfirebase();
//     });
//     print('city update to Firestore successfully');
//   } catch (e) {
//     print('Error city update to Firestore: $e');
//   }
// }

// updatecityfirebase(name, i) async {
//   try {
//     // FirebaseFirestore.instance.collection("City").doc().update({
//     //   "city": city
//     // });
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("City")
//         .where('name', isEqualTo: i)
//         .get();
//
//     print("iiiii:$i");
//     // Iterate over the documents and update the desired field
//     querySnapshot.docs.forEach((doc) async {
//       // Get the document reference
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection("City").doc(doc.id);
//
//       // Update the document with the given data
//       await docRef.update({"name": name});
//       print("updatecityyyynameeee: ${name}");
//       getcityfirebase();
//     });
//     print('city name update to Firestore successfully');
//   } catch (e) {
//     print('Error city name update to Firestore: $e');
//   }
// }
// updatecitydescriptionfirebase(description, i) async {
//   try {
//     // FirebaseFirestore.instance.collection("City").doc().update({
//     //   "city": city
//     // });
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("City")
//         .where('description', isEqualTo: i)
//         .get();
//
//     print("iiiii:$i");
//     // Iterate over the documents and update the desired field
//     querySnapshot.docs.forEach((doc) async {
//       // Get the document reference
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection("City").doc(doc.id);
//
//       // Update the document with the given data
//       await docRef.update({"description": description});
//       print("updatecityyyydescriptionnnn: ${description}");
//       getcitydescriptionfirebase();
//     });
//     print('city description update to Firestore successfully');
//   } catch (e) {
//     print('Error city description update to Firestore: $e');
//   }
// }
// updatecityratingfirebase(rating, i) async {
//   try {
//     // FirebaseFirestore.instance.collection("City").doc().update({
//     //   "city": city
//     // });
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("City")
//         .where('rating', isEqualTo: i)
//         .get();
//
//     print("iiiii:$i");
//     // Iterate over the documents and update the desired field
//     querySnapshot.docs.forEach((doc) async {
//       // Get the document reference
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection("City").doc(doc.id);
//
//       // Update the document with the given data
//       await docRef.update({"rating": rating});
//       print("updatecityyyyratinggg: ${rating}");
//       getcityratingfirebase();
//     });
//     print('city rating update to Firestore successfully');
//   } catch (e) {
//     print('Error city rating update to Firestore: $e');
//   }
// }

// getcityfirebase() async {
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection("City").where('city').get();
//
//   // Process the query snapshot
//   city.clear();
//   querySnapshot.docs.forEach((doc) {
//     print('City: ${doc['city']}');
//
//     setState(() {
//       city.add(doc['city']);
//     });
//
//     // Access data in each document
//     print('cityyyylist: ${city}');
//   });
// }

// getcitydescriptionfirebase() async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection("City")
//       .where('description')
//       .get();
//
//   // Process the query snapshot
//   description.clear();
//   querySnapshot.docs.forEach((doc) {
//     print('CityDescription: ${doc['description']}');
//
//     setState(() {
//       description.add(doc['description']);
//     });
//
//     // Access data in each document
//     print('descriptionlist: ${description}');
//   });
// }
//
// getcityratingfirebase() async {
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection("City")
//       .where('rating')
//       .get();
//
//   // Process the query snapshot
//   rating.clear();
//   querySnapshot.docs.forEach((doc) {
//     print('CityRating: ${doc['rating']}');
//
//     setState(() {
//       rating.add(doc['rating']);
//     });
//
//     // Access data in each document
//     print('ratinglist: ${rating}');
//   });
// }

// GestureDetector(
// //Add city
// onTap: () {
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: Text("Add City"),
// content: Container(
// height: 180,
// child: Column(
// children: [
// TextField(
// controller: _addcity,
// ),
// SizedBox(
// height: 30,
// ),
// ElevatedButton(
// onPressed: () {
// setState(() {
// addcityfirebase(
// _addcity.text.toString());
// getcityfirebase();
// // city.add(_addcity.text);
// Navigator.pop(context);
// //FirebaseFirestore.instance.collection('city').add('${_addcity.text}' as Map<String, dynamic>);
// });
// _addcity.clear();
// },
// child: Text("Add"))
// ],
// ),
// ),
// );
// },
// );
// },
// child: Container(
// height: 45,
// width: 60,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(blurRadius: 10, color: Colors.blue)
// ],
// borderRadius: BorderRadius.circular(20),
// color: Colors.white,
// ),
// child: Center(
// child: RichText(
// textAlign: TextAlign.center,
// text: TextSpan(children: <TextSpan>[
// TextSpan(children: [
// TextSpan(
// text: "Add city",
// style: GoogleFonts.josefinSans(
// fontSize: 18, color: Colors.black)),
// TextSpan(
// text: "+",
// style: GoogleFonts.josefinSans(
// fontSize: 30, color: Colors.black))
// ])
// ])),
// ),
// ), //Add city
// ),

//
// Scaffold(
// appBar: AppBar(
// elevation: 0,
// iconTheme: IconThemeData(color: Colors.black),
// backgroundColor: Colors.transparent,
// title: Text(
// "Cities",
// style: TextStyle(color: Colors.black),
// ),
// actions: [
// IconButton(
// onPressed: () {
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: Text("Add City"),
// content: SingleChildScrollView(
// child: Container(
// // height: 500,
// width: MediaQuery.sizeOf(context).width * 0.9,
// child: Column(
// children: [
// CircleAvatar(
// maxRadius: 40,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// decoration: InputDecoration(
// hintText: "Name", labelText: "Name"),
// controller: _addcity,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
// hintText: "Rating(1-10)",
// labelText: "Rating"),
// controller: _cityrating,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// maxLines: 5,
// decoration: InputDecoration(
// labelStyle:
// TextStyle(color: Colors.black),
// hintText: "Description",
// labelText: "Description",
// ),
// controller: _citydescription,
// ),
// SizedBox(
// height: 10,
// ),
// ElevatedButton(
// style: ButtonStyle(
// backgroundColor:
// MaterialStatePropertyAll(
// Colors.black),
// ),
// onPressed: () {
// setState(() {
// // addcityfirebase(
// //     _addcity.text.toString());
// addcitydetailsfirebase(
// _addcity.text.toString(),
// _cityrating.text.toString(),
// _citydescription.text.toString());
// //addcityphotofirebase(photo);
// getcityfirebase();
//
//
// Navigator.pop(context);
// //FirebaseFirestore.instance.collection('city').add('${_addcity.text}' as Map<String, dynamic>);
// });
// _addcity.clear();
// _citydescription.clear();
// _cityrating.clear();
// },
// child: Text("Add"))
// ],
// ),
// ),
// ));
// },
// );
// },
// icon: Icon(
// Icons.add,
// color: Colors.black,
// )),
// ],
// ),
// body: Container(
// padding: EdgeInsets.all(15),
// height: MediaQuery.sizeOf(context).height,
// width: MediaQuery.sizeOf(context).width,
// decoration: BoxDecoration(
// image: DecorationImage(
// opacity: 230,
// image: AssetImage("assets/images/1976998-1.jpg"),
// fit: BoxFit.cover)),
// child: Center(
// child: Container(
// //color: Colors.blue,
// height: MediaQuery.sizeOf(context).height,
// width: MediaQuery.sizeOf(context).width * 0.99,
// child: (cityname.isEmpty)
// ? Center(
// child: Text(
// "No data added yet",
// style: TextStyle(fontSize: 24),
// ))
//     : ListView.builder(
// itemCount: description.length,
// itemBuilder: (context, index) {
// if (index < cityname.length &&
// index < description.length &&
// index < rating.length) {
// return Container(
// height: 80,
// margin: EdgeInsets.all(5),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(10),
// boxShadow: [
// BoxShadow(color: Colors.grey, blurRadius: 5)
// ]),
// // child: Center(
// //     child: Text(
// //   "${city[index]}",
// //   style: TextStyle(fontSize: 24),
// // )),
// child: ListTile(
// leading: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Text("${index + 1}"),
// SizedBox(
// width: 5,
// ),
// CircleAvatar(
// maxRadius: 30,
// )
// ],
// ),
// title: Column(
// //mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "${cityname[index]}",
// style: TextStyle(fontSize: 24),
// ),
// Text(
// overflow: TextOverflow.ellipsis,
// "Description : ${description[index]}",
// style: TextStyle(
// fontSize: 15,
// ),
// ),
// Text(
// "Rating : ${rating[index]}",
// style: TextStyle(fontSize: 15),
// ),
// ],
// ),
// trailing: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// GestureDetector(
// //Add city
// onTap: () {
// print(
// "city[index]lllll: ${cityname[index]}");
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: Text("Update City"),
// content: SingleChildScrollView(
// child: Container(
// // height: 500,
// width:
// MediaQuery.sizeOf(context)
//     .width *
// 0.9,
// child: Column(
// children: [
// CircleAvatar(
// maxRadius: 40,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// decoration:
// InputDecoration(
// hintText:
// "Name",
// labelText:
// "Name"),
// controller: _updatecityname,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// keyboardType:
// TextInputType
//     .number,
// decoration:
// InputDecoration(
// hintText:
// "Rating(1-10)",
// labelText:
// "Rating"),
// controller: _updatecityrating,
// ),
// SizedBox(
// height: 10,
// ),
// TextField(
// maxLines: 5,
// decoration:
// InputDecoration(
// labelStyle: TextStyle(
// color:
// Colors.black),
// hintText:
// "Description",
// labelText:
// "Description",
// ),
// controller:
// _updatecitydescription,
// ),
// SizedBox(
// height: 10,
// ),
// ElevatedButton(
// style: ButtonStyle(
// backgroundColor:
// MaterialStatePropertyAll(
// Colors
//     .black),
// ),
// onPressed: () async{
// // showDialog(context: context, builder: (context) =>  Center(
// //   child: CircularProgressIndicator(
// //
// //     color: Colors.black,
// //   ),
// // ));
// await updatecityfirebase(_updatecityname.text.toString(),_updatecitydescription.text.toString(),_updatecityrating.text.toString(), index);
//
// setState(() {
// // updatecitydescriptionfirebase(_updatecitydescription, index);
// // updatecityratingfirebase(_updatecityrating, index);
// // addcityfirebase(
// //     _addcity.text.toString());
// getcityfirebase();
// // getcityratingfirebase();
// // getcitydescriptionfirebase();
// // city.add(_addcity.text);
// Navigator.of(context).pop();
// //FirebaseFirestore.instance.collection('city').add('${_addcity.text}' as Map<String, dynamic>);
// });
// // _updatecityname.clear();
// // _updatecitydescription.clear();
// // _updatecityname.clear();
// },
// child: Text("Update"))
// ],
// ),
// ),
// ));
// },
// );
// },
// child: Icon(Icons.edit), //Add city
// ),
// SizedBox(
// width: 15,
// ),
// GestureDetector(
// onTap: () async {
// showDialog(context: context, builder: (context) =>  Center(
// child: CircularProgressIndicator(
//
// color: Colors.black,
// ),
// ));
//
// await deletecitynamefirebase(
// cityname[index]);
// await deletecitydescriptionfirebase(
// description[index]);
// await deletecityratingfirebase(
// rating[index]);
// Navigator.of(context).pop();
//
//
// },
// child: Icon(Icons.delete))
// ],
// ),
// ),
// );
// }
// ;
// }),
// ),
// ),
// ));
