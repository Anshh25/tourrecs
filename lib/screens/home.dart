import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/1976998-1.jpg"),
                  fit: BoxFit.cover)),
          // child: Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     // SizedBox(height: MediaQuery.sizeOf(context).height*0.1,),
          //     Positioned(
          //       top: MediaQuery.sizeOf(context).height * 0.07,
          //       right: 10,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           IconButton(
          //               onPressed: () {},
          //               icon: Icon(Icons.account_circle_rounded),
          //               iconSize: 65),
          //           IconButton(
          //               onPressed: () {},
          //               icon: Icon(Icons.account_circle_rounded),
          //               iconSize: 40),
          //         ],
          //       ),
          //     ),
          //     Positioned(
          //       left: MediaQuery.sizeOf(context).width * 0.02,
          //       top: MediaQuery.sizeOf(context).height * 0.2,
          //       child: Container(
          //         child: Center(
          //           child: Text(
          //             textAlign: TextAlign.center,
          //             "Explore",
          //             style: TextStyle(
          //                 fontSize: 32,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black),
          //           ),
          //         ),
          //         margin: EdgeInsets.all(10),
          //         height: MediaQuery.sizeOf(context).height * 0.065,
          //         width: MediaQuery.sizeOf(context).width * 0.38,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //           boxShadow: [
          //             BoxShadow(
          //               blurStyle: BlurStyle.outer,
          //               blurRadius: 16,
          //               color: Colors.grey,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       top: MediaQuery.sizeOf(context).height * 0.3,
          //       left: 20,
          //       height: 240,
          //       child: ListView.builder(
          //           itemCount: 5,
          //           shrinkWrap: true,
          //           physics: ClampingScrollPhysics(),
          //           scrollDirection: Axis.horizontal,
          //           itemBuilder: (context, index) {
          //             return Container(
          //               margin: EdgeInsets.only(right: 8),
          //               child: Stack(
          //                 children: [
          //
          //                   ClipRRect(
          //                     borderRadius: BorderRadius.circular(16),
          //                     child: CachedNetworkImage(
          //                       imageUrl: "https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
          //                       height: 220,
          //                       width: 150,
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                   Container(
          //                     height: 200,
          //                     width: 150,
          //                     child: Column(
          //                       children: [
          //                         Row(
          //                           children: [
          //                             Container(
          //                                 margin: EdgeInsets.only(left: 8, top: 8),
          //                                 padding:
          //                                 EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          //                                 decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.circular(8),
          //                                     color: Colors.white38),
          //                                 child: Text(
          //                                   "New",
          //                                   style: TextStyle(color: Colors.white),
          //                                 ))
          //                           ],
          //                         ),
          //                         Spacer(),
          //                         Row(
          //                           children: [
          //                             Container(
          //                               margin: EdgeInsets.only(bottom: 10, left: 8, right: 8),
          //                               child: Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   Container(
          //                                     child: Text(
          //                                       "Thailand",
          //                                       style: TextStyle(
          //                                           color: Colors.white,
          //                                           fontWeight: FontWeight.w600,
          //                                           fontSize: 16),
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     height: 3,
          //                                   ),
          //                                   Text(
          //                                     "18 Tours",
          //                                     style: TextStyle(
          //                                         color: Colors.white,
          //                                         fontWeight: FontWeight.w600,
          //                                         fontSize: 13),
          //                                   )
          //                                 ],
          //                               ),
          //                             ),
          //                             Spacer(),
          //                             Container(
          //                                 margin: EdgeInsets.only(bottom: 10, right: 8),
          //                                 padding:
          //                                 EdgeInsets.symmetric(horizontal: 3, vertical: 7),
          //                                 decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.circular(3),
          //                                     color: Colors.white38),
          //                                 child: Column(
          //                                   children: [
          //                                     Text(
          //                                       "4.5",
          //                                       style: TextStyle(
          //                                           color: Colors.white,
          //                                           fontWeight: FontWeight.w600,
          //                                           fontSize: 13),
          //                                     ),
          //                                     SizedBox(
          //                                       height: 2,
          //                                     ),
          //                                     Icon(
          //                                       Icons.star,
          //                                       color: Colors.white,
          //                                       size: 20,
          //                                     )
          //                                   ],
          //                                 ))
          //                           ],
          //                         )
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             );
          //           }),
          //     ),
          //     // ),
          //
          //     Positioned(
          //       bottom: MediaQuery.sizeOf(context).height * 0.002,
          //       child: Container(
          //         margin: EdgeInsets.all(10),
          //         height: MediaQuery.sizeOf(context).height * 0.085,
          //         width: MediaQuery.sizeOf(context).width * 0.95,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10),
          //           boxShadow: [
          //             BoxShadow(
          //               blurStyle: BlurStyle.outer,
          //               blurRadius: 16,
          //               color: Colors.grey,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //
          //   ],
          // ),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.account_circle_rounded),
                                  iconSize: 65),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.account_circle_rounded),
                                  iconSize: 40),
                ],

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Explore",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.sizeOf(context).height * 0.065,
                    width: MediaQuery.sizeOf(context).width * 0.38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 16,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 240,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://images.pexels.com/photos/1659438/pexels-photo-1659438.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                              height: 220,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 150,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 8, top: 8),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white38),
                                        child: Text(
                                          "New",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: 10, left: 8, right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Thailand",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            "18 Tours",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                        margin: EdgeInsets.only(
                                            bottom: 10, right: 8),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3, vertical: 7),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.white38),
                                        child: Column(
                                          children: [
                                            Text(
                                              "4.5",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          ],
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
