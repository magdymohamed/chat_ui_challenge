import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_view/split_view.dart';

class spilitviewer extends StatefulWidget {
  @override
  _spilitviewerState createState() => _spilitviewerState();
}

class _spilitviewerState extends State<spilitviewer>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.person_outline,
    Icons.view_list,
  ];

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#373A36'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: NavigationScreen(
          iconList[_bottomNavIndex],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff7755cd),
                borderRadius: BorderRadius.circular(50)),
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              Icons.chat_bubble,
              color: Colors.white,
              size: 15,
            ),
          ),
          onPressed: () {
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        activeColor: HexColor('#FFA400'),
        splashColor: HexColor('#FFA400'),
        inactiveColor: Colors.blue,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final IconData iconData;

  NavigationScreen(this.iconData) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  bool Currenttab = true;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(80, 80),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: SplitView(
            initialWeight: 0.2,
            view1: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color(0xff7755cd),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          color: Color(0xff7755cd),
                          child: Center(
                              child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                        ),
                        Center(
                          child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                Currenttab ? "Active Friends" : "New Groups",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Color(0xfff4f4f3),
                    child: Center(
                      child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            Currenttab ? "Friends" : "Groups",
                            style: TextStyle(
                                color: Color(0xff7755cd),
                                fontWeight: FontWeight.w900,
                                fontSize: 24),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            view2: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                Currenttab = true;
                              });
                            },
                            child: Center(
                              child: Text(
                                "Chat",
                                style: TextStyle(
                                    color: Currenttab
                                        ? Colors.black
                                        : Color(0xffA4B4C3),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                Currenttab = false;
                              });
                            },
                            child: Center(
                              child: Text(
                                "Groups",
                                style: TextStyle(
                                    color: !Currenttab
                                        ? Colors.black
                                        : Color(0xffA4B4C3),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25),
                              ),
                            ),
                          )
                        ],
                      ),
                      Center(
                        child: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Currenttab
                    ? Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 140,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                children: [
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user1.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Skyler",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "walter",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user3.jpeg'),
                                                      fit: BoxFit.fitWidth,
                                                      height: 65,
                                                      width: 65,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Matilda",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitWidth,
                                                      height: 65,
                                                      width: 65,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Skyler",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user1.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Skyler",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 90,
                                      width: 90,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'lib/assets/user1.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 20,
                                                      width: 20,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Skyler",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                                child: ListView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 0),
                              children: [
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7755cd),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                          Color(0xff7755cd),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            child: Image(
                                              image: AssetImage(
                                                  'lib/assets/user1.jpg'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Johan victor",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "11:30pm",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w900,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            "hi johan how are you i really miss you man")),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                          Color(0xff7755cd),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              50)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "3",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 140,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 38.0, right: 38),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Create  New Group",
                                        style: TextStyle(
                                            color: Color(0xffA4B4C3),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              children: <Widget>[
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 2.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user1.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image(
                                                  image: AssetImage(
                                                      'lib/assets/user2.jpg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Stack(
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          'lib/assets/user2.jpg'),
                                                      fit: BoxFit.fitHeight,
                                                      color: Color(0xff7755cd),
                                                    ),
                                                    Positioned.fill(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "+75",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Group1",
                                          style: TextStyle(
                                              color: !Currenttab
                                                  ? Colors.black
                                                  : Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "2013-2017 Batch",
                                          style: TextStyle(
                                              color: Color(0xffA4B4C3),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
              ],
            ),
            viewMode: SplitViewMode.Horizontal,
            gripSize: 0.2,
            onWeightChanged: (w) => print("Vertical $w"),
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
