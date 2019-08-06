import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:unilesson_admin/ui/widgets/lessons_list.dart';

class MainHomeTeacher extends StatefulWidget {
  final FirebaseUser user;
  final Function(bool v) notifyParent;

  MainHomeTeacher(Key key, this.user, this.notifyParent) : super(key: key);

  @override
  _MainHome createState() => new _MainHome();
}

class _MainHome extends State<MainHomeTeacher> {
  final TextEditingController _search = new TextEditingController();

  refresh() {
    //SearchList(UniqueKey(), widget.user, widget.notifyParent(true));
    //widget.notifyParent(true);
    //SearchList(UniqueKey(), widget.user, widget.notifyParent(true));
    // widget.notifyParent(true);
     Timer(const Duration(milliseconds: 100), () {
       widget.notifyParent(true);
       //SearchList(UniqueKey(), widget.user, widget.notifyParent(true));
    });
    //widget.notifyParent(true);
   
  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: Auth.getUser(widget.user.uid),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(212, 20, 15, 1.0),
                ),
              ),
            );
          } else {
            return new ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: _height / 20,
                      left: _height / 35,
                      right: _height / 35),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: (snapshot.data.profilePictureURL !=
                                  '')
                              ? NetworkImage(snapshot.data.profilePictureURL)
                              : AssetImage("assets/img/face.png"),
                          radius: _height / 30,
                        ),
                        new SizedBox(
                          height: 30,
                        ),
                        new Text(
                          "Ciao " + snapshot.data.name + '.',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new SizedBox(
                          height: 20,
                        ),
                        new Text(
                          "Sembra che oggi sia la giornata giusta per aiutare qualcuno.",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 30.0, right: 0),
                            child: new Text(
                              'Le tue lezioni',
                              style: TextStyle(fontSize: 23),
                            )),
                        new SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
                LessonsList(UniqueKey(), widget.user, refresh),
              ],
            );
          }
        });
  }
}
