import 'package:flutter/material.dart';
import 'package:unilesson_admin/ui/screens/main_screen_student.dart';
import 'package:unilesson_admin/ui/screens/main_screen_teacher.dart';
import 'package:unilesson_admin/ui/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Container(
            color: Colors.white,
          );
        } else {
          if (snapshot.hasData) {
            return new StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(snapshot.data.uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot2) {
                  if (!snapshot2.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(212, 20, 15, 1.0),
                        ),
                      ),
                    );
                  } else {
                  print('user is a a ' + snapshot2.data['role']);
                  if(snapshot2.data['role'] == 'teacher')
                    return new MainScreenTeacher(
                        firebaseUser: snapshot.data,
                        );
                  else return new MainScreenStudent(
                        firebaseUser: snapshot.data,
                        );
                }});
          } else {
            return WelcomeScreen();
          }
        }
      },
    );
  }
}
