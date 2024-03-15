import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Place extends StatefulWidget {
  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  late List<String> cities;
  late String selectedCity;
   var selectedId;
  GlobalKey<FormState> _addformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _updateformKey = GlobalKey<FormState>();
  TextEditingController _addcityname = TextEditingController();
  TextEditingController _addplacename = TextEditingController();
  TextEditingController _addplacerating = TextEditingController();
  TextEditingController _addplacedescription = TextEditingController();
  TextEditingController _updateplacename = TextEditingController();
  TextEditingController _updateplacerating = TextEditingController();
  TextEditingController _updateplacedescription = TextEditingController();
String cityid = "";
String cityname = "";
String created_at = "";
String admin = "";
List adminlist = [];
List placename = [];
List cityyname = [];
List rating = [];
List description = [];
var image;
var imageTemp;
String imgUrl = '';
  addplacedetailsfirebase(name , cityname , rating , description, image) async{

    DocumentReference docRef = FirebaseFirestore.instance.collection("Places").doc();
    String DocumentId = docRef.id;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('City')
        .where('name', isEqualTo: cityname)
        .limit(1)
        .get();
    var ctyId;
    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        ctyId = querySnapshot.docs[0].id;
      });
    }

    QuerySnapshot Admin = await FirebaseFirestore.instance.collection('admins')
        .limit(1)
        .get();
    String adminname = Admin.docs.first['name'];
    setState(() {
      admin = adminname;
    });

   // created_at = DateTime.now().toString();



    try{
      FirebaseFirestore.instance.collection("Places").add({
        "cityid" : ctyId,
        "cityname" : cityname,
        "id" : DocumentId,
        "name" : name,
        "image" : image,
        "rating" : rating,
        "description" : description,

      });
    }
        catch(e){
      print(e);
        }
        Navigator.pop(context);
  }

  getplacedetailsfirebase()async{
    QuerySnapshot querySnapshot = await
    FirebaseFirestore.instance.collection("Places").get();

    querySnapshot.docs.forEach((doc) {
      setState(() {
        placename.add(doc['name']);
        cityyname.add(doc['name']);
        rating.add(doc['name']);
        description.add(doc['name']);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCities();
  }
  Future<void> fetchCities() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('City').get();

    List<String> cityNames = [];
    querySnapshot.docs.forEach((doc) {
      cityNames.add(doc['name']); // Assuming 'name' is the field name in Firestore
      selectedCity = doc['name'];
    });

    setState(() {
      cities = cityNames;
    });
  }
  Future pickImage() async{
    try{
      var image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      File? imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    }
        catch(e){
      print(e);
        }

  }
  Future uploadImage() async{
    String imageFileName = DateTime.now().toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirPlaceImages = referenceRoot.child('placeImages');
    Reference referenceImageToUpload = referenceDirPlaceImages.child(imageFileName);
    try{
      await referenceImageToUpload.putFile(File(image!.path),SettableMetadata(contentType: 'image/jpeg'));
      imgUrl = await referenceImageToUpload.getDownloadURL();
    }
        catch(e){
      print(e);
        }

  }
//   updatecircleavatar(){
//     setState(() {
//
//     });
// ;
//   }

  @override
  Widget build(BuildContext context) {
    StateSetter _setState;
    return Scaffold(

      appBar: AppBar(
        // actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Place",style: TextStyle(color: Colors.black),),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  // Handle search icon button press
                  showSearch(context: context, delegate: PlaceSearch());
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              IconButton(splashRadius: 25,onPressed: () {
                showDialog(context: context, builder: (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                    _setState = setState;
                    return  AlertDialog(

                      backgroundColor: Colors.grey.shade100,
                      title: Text("Add Place"),
                      content: Form(
                        key: _addformKey,
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.sizeOf(context).width*0.98,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Stack(
                                  children: [
                                     CircleAvatar(
                                      backgroundImage:(image != null)?
                                      FileImage(image!) : null,
                                      maxRadius: 70,
                                    ),

                                    Positioned(bottom: 0,right: -10,child: IconButton(onPressed: () async{
                                     await pickImage();
                                     setState(() {});

                                     //uploadImage();


                                    },icon: Icon(Icons.add_a_photo_rounded),))
                                  ],
                                ),
                                TextField(
                                  controller: _addplacename,
                                  decoration: InputDecoration(labelText: "Name",hintText: "Name"),
                                ),
                                SizedBox(height: 10,),
                                // TextField(
                                //   controller: _addcityname,
                                //   decoration: InputDecoration(labelText: "City",hintText: "City"),
                                // ),
                                Align( alignment: Alignment.topLeft,child: Text("City :",textAlign: TextAlign.start)),

                                DropdownButton(
                                  isExpanded: true ,
                                  value: selectedCity,
                                  items: cities.map((String city) {
                                    return DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCity = value.toString();
                                    });
                                  },
                                  hint: Text('Select City'),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _addplacerating,
                                  decoration: InputDecoration(labelText: "Rating",hintText: "Rating(1-5)"),
                                ),
                                SizedBox(height: 10,),
                                TextField(
                                  controller: _addplacedescription,
                                  maxLines: 5,
                                  decoration: InputDecoration(labelText: "Description",hintText: "Description",),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(style: ButtonStyle(splashFactory: InkRipple.splashFactory,),onPressed: () async{
                          await addplacedetailsfirebase(_addplacename.text, selectedCity, _addplacerating.text, _addplacedescription.text, imgUrl);



                        }, child: Text("Add."))
                      ],
                    );
                  },);
                },);


              }, icon: Icon(Icons.add,size: 35,color: Colors.black,),),
            ],
          )
        ],
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 230,
              image: AssetImage("assets/images/1976998-1.jpg"),
              fit: BoxFit.cover),
        ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Places").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot ){
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
                  child: Text('No Places found'),
                );
              }
              final places = snapshot.data!.docs;
              return ListView.builder(itemCount: snapshot.data!.docs.length
                ,itemBuilder: (context, index) {

                final place = places[index];
              final placeData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Container(
                  //height: ,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    elevation: 2,
                    child: Center(
                      child: ListTile(
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          //mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("${placeData['name']}",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20)),
                            Text("City : ${placeData['cityname']}",style: TextStyle(fontSize: 16)),
                            Text("Rating : ${placeData['rating']}",style: TextStyle(fontSize: 16),),
                            Text("Description : ${placeData['description']}",style: TextStyle(fontSize: 16,overflow: TextOverflow.ellipsis),),
                          ],
                        ),
                        leading: CircleAvatar(
                          maxRadius: 40,
                          backgroundImage: NetworkImage("${placeData['image']}"),



                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {
                              setState(() {
                                showDialog(context: context, builder: (BuildContext context) {
                                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                    _setState = setState;
                                    return AlertDialog(

                                      backgroundColor: Colors.grey.shade100,
                                      title: Text("Update Place"),
                                      content: Form(
                                        key: _updateformKey,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            width: MediaQuery.sizeOf(context).width*0.98,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,

                                              children: [
                                                Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      maxRadius: 70,
                                                      backgroundImage: (image != null) ? FileImage(image!)  : NetworkImage("${placeData['image']}") as ImageProvider<Object>?,
                                                    ),
                                                    (image != null)
                                                        ? CircleAvatar(
                                                      backgroundImage:
                                                      FileImage(image!),
                                                      maxRadius: 70,
                                                    )
                                                        : CircleAvatar(
                                                      backgroundImage: NetworkImage("${placeData['image']}"),
                                                      maxRadius: 70,
                                                    ),

                                                    Positioned(bottom: 0,right: -10,child: IconButton(onPressed: () async{
                                                      await pickImage();
                                                      setState(() {});


                                                    },icon: Icon(Icons.add_a_photo_rounded),))
                                                  ],
                                                ),
                                                TextField(
                                                  controller: _updateplacename = TextEditingController(text :"${placeData['name']}") ,
                                                  decoration: InputDecoration(labelText: "Name",hintText: "Name"),
                                                ),
                                                SizedBox(height: 10,),
                                                Align( alignment: Alignment.topLeft,child: Text("City :",textAlign: TextAlign.start)),

                                                DropdownButton(
                                                  isExpanded: true ,
                                                  value: selectedCity,
                                                  items: cities.map((String city) {
                                                    return DropdownMenuItem(
                                                      value: city,
                                                      child: Text(city),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCity = value.toString();
                                                    });
                                                  },
                                                  hint: Text('Select City'),
                                                ),
                                                TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: _updateplacerating  = TextEditingController(text :"${placeData['rating']}") ,
                                                  decoration: InputDecoration(labelText: "Rating",hintText: "Rating(1-5)"),
                                                ),
                                                SizedBox(height: 10,),
                                                TextField(
                                                  controller: _updateplacedescription  = TextEditingController(text :"${placeData['description']}") ,
                                                  maxLines: 5,
                                                  decoration: InputDecoration(labelText: "Description",hintText: "Description",),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () async{
                                          // setState(() {
                                          //   image = imageTemp;
                                          //  // imgUrl = image!.path.toString();
                                          //
                                          // });
                                          await uploadImage();
                                          await FirebaseFirestore.instance.collection("Places").doc(snapshot.data!.docs[index].id).update({
                                            'name' : _updateplacename.text,
                                            'rating' : _updateplacerating.text,
                                            'description' : _updateplacedescription.text,
                                            'image' : imgUrl.toString()

                                          }).then((value) => Navigator.of(context).pop());

                                          //await uploadImage();


                                        }, child: Text("Update."))
                                      ],
                                    );

                                  },);
                                },);
                              });

                            }, icon: Icon(Icons.edit,color: Colors.grey),splashRadius: 25),
                            IconButton(onPressed: () async{
                              await FirebaseFirestore.instance.collection("Places").doc(snapshot.data!.docs[index].id).delete();

                            }, icon: Icon(Icons.delete,color: Colors.grey),splashRadius: 25,),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },);
            }
          )),
    );
  }
}

class PlaceSearch extends SearchDelegate<String>{

  final CollectionReference citiesRef =
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:  NetworkImage("${data['image']}"),
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

