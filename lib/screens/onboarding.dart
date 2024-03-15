import 'package:flutter/material.dart';
import 'package:tourrecs/screens/signin.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  var currentpage = 0;
  PageController _pageController = PageController();

  onChanged(int index) {
    setState(() {
      currentpage = index;
    });
  }

  List Onboardingdata = [
    {
      "image": 'assets/images/onboardingimage/onboarding1.jpg',
      "title1": 'GET',
      "title2": 'RECOMMENDATIONS',
      "content": 'Sit, relax and get the best travel recommendations from us.'
    },
    {
      "image": 'assets/images/onboardingimage/onboarding2.jpg',
      "title1": 'DISCOVER',
      "title2": 'NEW PLACES',
      "content": 'Explore new travel destinations through our app.'
    },
    {
      "image": 'assets/images/onboardingimage/onboarding3.jpg',
      "title1": 'SHARE',
      "title2": 'MEMORIES',
      "content": 'Share your weekend tour with others.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.09,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage(),));
                  },
                  child: Text((currentpage==2)?""
                   : "Skip >",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          // SizedBox(
          //   height: MediaQuery.sizeOf(context).height * 0.1,
          // ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.74,
            child: PageView.builder(
              onPageChanged: onChanged,
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              itemCount: Onboardingdata.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height*0.007),
                    Image.asset(Onboardingdata[index]['image']),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Onboardingdata[index]['title1'],
                            style: TextStyle(
                                fontSize: 34,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Onboardingdata[index]['title2'],
                            style: TextStyle(
                                fontSize: 34,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 100),
                      child: Text(
                        Onboardingdata[index]['content'],
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: TextStyle(

                          fontSize: 20,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    //
                    // SizedBox(height: 10,),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start  ,
                  children: List.generate(Onboardingdata.length, (index) {
                    return AnimatedContainer(
                      duration: Duration(microseconds: 200),
                      height: 12,
                      width: (index == currentpage) ? 50 : 10,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (index == currentpage)
                              ? Colors.black
                              : Colors.grey),
                    );
                  }),
                ),
                GestureDetector(onTap: () {
                  _pageController.nextPage(duration: Duration(milliseconds: 400), curve:  Curves.easeIn);
                  if(currentpage == 2){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage(),));
                  }
                },
                  child: Container(
                    margin: EdgeInsets.only(right: 35),
                    //padding: EdgeInsets.only(right: 50),79
                    height: 59,
                    width: 89,

                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Icon(Icons.navigate_next_sharp, color: Colors.white,size: 45,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
