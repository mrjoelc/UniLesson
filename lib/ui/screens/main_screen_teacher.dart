import 'package:flutter/material.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unilesson_admin/ui/screens/welcome_screen.dart';
import 'package:unilesson_admin/ui/widgets/main_favorites.dart';
import 'package:unilesson_admin/ui/widgets/main_home_student.dart';
import 'package:unilesson_admin/ui/widgets/main_home_teacher.dart';
import 'package:unilesson_admin/ui/widgets/main_user_profile.dart';
import 'package:unilesson_admin/ui/widgets/new_lesson.dart';

class MainScreenTeacher extends StatefulWidget {
  final FirebaseUser firebaseUser;
  String role;
  Function notifyParent;

  MainScreenTeacher({this.firebaseUser, this.role});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenTeacher> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<Widget> _childrenStudent;
  List<Widget> _childrenTeacher;
  bool ist;
  String isTeacher;

  @override
  void initState() {
    super.initState();

    _childrenTeacher = [
      MainHomeTeacher(UniqueKey(), widget.firebaseUser, refreshToHome),
      NewLessonPage(widget.firebaseUser, refreshToHome),
      MainUserProfile(widget.firebaseUser)
    ];
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
    return teacherScaffold();
  }

  //widget.role == 'teacher' ? _childrenTeacher[_currentIndex] : _childrenStudent[_currentIndex]

  void _logOut() async {
    Auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  _handleUser() async {
    String isTeacher = await Auth.getRole(widget.firebaseUser.uid).first;
    if(isTeacher == 'teacher') {
      return true;
    } else {
      return false;
    }
  }

  // Widget _handleWidgetScreens() {
  //   if (isTeacher) return teacherScaffold();
  //   return studentScaffold();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget teacherScaffold() {
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
      body:  _childrenTeacher[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
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
      body: Text("student "),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(_handleUser() ? Icons.add_to_photos : Icons.favorite),
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
