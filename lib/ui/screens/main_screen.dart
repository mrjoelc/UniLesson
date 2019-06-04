import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:unilesson_admin/ui/widgets/main_user_profile.dart';
import 'package:unilesson_admin/ui/widgets/main_home.dart';
import 'package:unilesson_admin/ui/widgets/custom_card.dart';
import 'package:unilesson_admin/ui/widgets/new_lesson.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  MainScreen({this.firebaseUser});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  //FirebaseUser firebaseUser;


  @override
  void initState() {
    super.initState();
  }

  refresh(bool v) {
     setState(() {
        print('dentroRefresh');
    });
  }

  refreshToHome(bool v) {
     v ? setState(() {
        _currentIndex=0;
         print('dentroRefreshToHome');
    }) : print('FuoriRefreshToHome');
    
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [MainHome(UniqueKey(), widget.firebaseUser, refresh), NewLessonPage(widget.firebaseUser, refreshToHome), MainUserProfile(widget.firebaseUser)];

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Image(image: AssetImage('assets/img/logo.png'), width: 50,),
        centerTitle: true,
        
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: Text('Esci'),
              onTap: () {
                _logOut();
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      body:  _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos), title: Text('Lezione')),
          BottomNavigationBarItem(
              icon: Icon(Icons.face), title: Text('Profilo')), 
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.redAccent[700],
      ),
    );
  }


  void _logOut() async {
    Auth.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
