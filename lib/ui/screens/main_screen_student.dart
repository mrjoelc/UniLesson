import 'package:flutter/material.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unilesson_admin/ui/screens/welcome_screen.dart';
import 'package:unilesson_admin/ui/widgets/main_favorites.dart';
import 'package:unilesson_admin/ui/widgets/main_home_student.dart';
import 'package:unilesson_admin/ui/widgets/main_home_teacher.dart';
import 'package:unilesson_admin/ui/widgets/main_user_profile.dart';
import 'package:unilesson_admin/ui/widgets/new_lesson.dart';

class MainScreenStudent extends StatefulWidget {
  final FirebaseUser firebaseUser;
  String role;
  Function notifyParent;

  MainScreenStudent({this.firebaseUser, this.role});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenStudent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<Widget> _childrenStudent;

  bool isTeacher;

  @override
  void initState() {
    super.initState();

    _childrenStudent = [
      MainHomeStudent(widget.firebaseUser),
      MainFavorites(widget.firebaseUser),
      MainUserProfile(widget.firebaseUser)
    ];
  }

  refresh(bool v) {
    setState(() {
      print('dentroRefresh');
    });
  }

  refreshToHome(bool v) {
    v
        ? setState(() {
            _currentIndex = 0;
            print('dentroRefreshToHome');
          })
        : print('FuoriRefreshToHome');
  }

  @override
  Widget build(BuildContext context) {
    return  studentScaffold();
  }

  void _logOut() async {
    Auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }



  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  Widget studentScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Image(
          image: AssetImage('assets/img/logo.png'),
          width: 50,
        ),
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
      body:  _childrenStudent[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Lezione')),
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
}
