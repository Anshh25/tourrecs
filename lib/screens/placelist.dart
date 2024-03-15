import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourrecs/screens/populardestinations.dart';

class PlaceList extends StatefulWidget {
  final String cityId;
  final String cityName;

  const PlaceList({super.key, required this.cityId, required this.cityName});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          widget.cityName,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 240,
              image: AssetImage("assets/images/1976998-1.jpg"),
              fit: BoxFit.cover),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Places')
              .where('cityname', isEqualTo: widget.cityName)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container( height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          opacity: 230,
                          image: AssetImage("assets/images/1976998-1.jpg"),
                          fit: BoxFit.cover)),child: Center(child:  CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            // Check if the query snapshot has no data
            if (snapshot.data!.docs.isEmpty) {
              return Container( height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          opacity: 230,
                          image: AssetImage("assets/images/1976998-1.jpg"),
                          fit: BoxFit.cover)),child: Center(child:  Text('No Place found'),));

            }
            // final places = snapshot.data!.docs as Map<String, dynamic>;
            List<Map<String, dynamic>> placesList = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
            final places = snapshot.data!.docs;

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final place = places[index];
                final placeData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                //var data = documents[index].data() as Map<String, dynamic>;
                //   var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var data = placesList[index];
                Future<ImageProvider> _getImage() async {
                  final url = "${data['image']}";
                  final image = NetworkImage(url);
                  await precacheImage(image, context); // Pre-cache the image
                  return image;
                }

                return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PopularDestinations(id: 'id', collection: 'Places'),));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularDestinations(
                                id: '${placeData['id']}',
                                collection: 'Places',
                                name: '${placeData['name']}',
                              )),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Center(
                      child: ListTile(
                        title: Text(data['name']),
                        leading: FutureBuilder(
                          future: _getImage(), // Method to fetch image asynchronously
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 20,
                                child: CircularProgressIndicator(),
                                backgroundColor: Colors.white,
                              );
                            } else if (snapshot.hasError) {
                              return CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.error), // Display error icon if image loading fails
                              );
                            } else {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage("${data['image']}"),
                              );
                            }
                          },
                        ),
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage("${data['image']}"),
                        // ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
