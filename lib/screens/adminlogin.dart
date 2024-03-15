import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourrecs/screens/adminpage.dart';
import 'package:tourrecs/screens/home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  TextEditingController _adminusername = TextEditingController();
  TextEditingController _adminpassword = TextEditingController();
   var error;

 Future<String> adminlogin(adminname,password) async {

    String response = "Something wents wrong";

    late DocumentSnapshot documentSnapshot;

    await FirebaseFirestore.instance
        .collection('/admins').limit(1)
        .get()
        .then((QuerySnapshot docSnapshot) {

      documentSnapshot = docSnapshot.docs.first;
      print("documentSnapshot.data()");
      print(documentSnapshot.data());
    });
    
    if(documentSnapshot.get("name")==adminname){
      if(documentSnapshot.get("password")==password){
        return response = "Success";
      }
    }

    else if (documentSnapshot.get("name")!=adminname){
      Fluttertoast.showToast(msg: "username dont exist");
    }
    return response;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(18),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 230,
                image: AssetImage("assets/images/1976998-1.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.26,
              ),
              Text(
                "Admin",
                style: GoogleFonts.poppins(
                    fontSize: 46, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
              ),
              Text(
                "Username:",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600, fontSize: 20),
              ),
              TextField(
                controller: _adminusername,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Text(
                "Password:",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w600, fontSize: 20),
              ),
              TextField(
                controller: _adminpassword,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: GestureDetector(onTap: ()async{ String responseeee = await adminlogin(_adminusername.text.toString(), _adminpassword.text.toString());
                if(responseeee=="Success"){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> AdminPage()));
                } else Fluttertoast.showToast(msg: "Something went wrong");},
                  child: Container(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black,),
                    child: Center(child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),)),
                  ),
                ),
              ),
              // Center(
              //   child: ElevatedButton(onPressed: () async {
              //
              //   }, child: Text("Login")),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
