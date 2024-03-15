import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  TextEditingController _username = TextEditingController();
  TextEditingController _useremail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
       // titleTextStyle: TextStyle(color: Colors.black),
        title:Text(
          "Users",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:Container(
        padding: EdgeInsets.all(12),
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
        child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots()
        ,builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return  ListView.builder(
          itemCount: snapshot.data!.docs.length
          ,itemBuilder: (context, index) {
            final userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                 showDialog(context: context, builder: (context) {
                   return AlertDialog(
                     //title: Text("data"),
                     content: Container(
                       width: MediaQuery.sizeOf(context).width*0.9,
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           CircleAvatar(
                             backgroundImage: NetworkImage("${userData['photourl']}"),
                             maxRadius: 70,
                           ),
                           SizedBox(height: 10,),
                           Align(alignment: Alignment.topLeft,
                   child: Text("Name:")),
                           TextField(
                             enabled: false,

                             controller: _username = TextEditingController(text: "${userData['displayname']}") ,
                           ),
                           SizedBox(height: 10,),
                           Align(alignment: Alignment.topLeft,
                               child: Text("Email:")),
                           TextField(
                             enabled: false,
                             controller: _useremail = TextEditingController(text: "${userData['email']}") ,
                           ),
                         ],
                       ),
                     ),
                   );
                 },);
              },
              child: Container(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  elevation: 2,
                  child: ListTile(
                    title: Text("${userData['displayname']}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("${userData['photourl']}"),
                    ),
                    trailing: IconButton(onPressed: ()async{
                      await FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id).delete();

                    },icon: Icon(Icons.delete)),

                  ),
                ),
              ),
            );
          },);

        },),
      )
    );
  }
}
