import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/models/user.dart';

class MainUserProfile extends StatefulWidget {
  final FirebaseUser user;

  MainUserProfile(this.user);

  _MainUserProfile createState() => _MainUserProfile();
}

class _MainUserProfile extends State<MainUserProfile> {
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
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
          return new Container(
              //color: Colors.white,
              margin: EdgeInsets.all(25.0),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 8),
                    )
                  ]),
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: new Padding(
                          padding: EdgeInsets.all(25),
                          child: new Column(children: <Widget>[
                            buildFaceAndName(
                                _height,
                                _width,
                                snapshot.data.profilePictureURL,
                                snapshot.data.name,
                                snapshot.data.surname),
                            new Column(children: <Widget>[
                              buildInfoButton(),
                              buildInfoChild('Email', snapshot.data.email),
                              buildInfoChild('Numero', snapshot.data.number),
                              buildInfoChild(
                                  'Università', snapshot.data.university),
                              buildInfoChild('Corso di Laurea di appartenenza',
                                  snapshot.data.cdl),
                            ]),
                          ])))));
        }
      },
    );
  }
}

Widget buildInfoChild(String label, data) => new Container(
      width: 300,
      height: 70,
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyle(fontSize: 13, color: Colors.black54)),
          Text(
            data,
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );

Widget buildFaceAndName(double _height, double _width, url, name, surname) =>
    new Row(
      children: <Widget>[
        new CircleAvatar(
          backgroundImage: (url != '')
              ? NetworkImage(url)
              : AssetImage("assets/img/face.png"),
          radius: _height / 14,
        ),
        new SizedBox(
          width: _width / 2.4,
          child: new Text(
            '$name $surname',
            style: new TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

Widget buildInfoButton() => new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30, bottom: 20),
      width: 150,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.redAccent[700]),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: new Text(
        "Info personali",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.redAccent[700]),
      ),
    );

Widget buildEditButton() => new FloatingActionButton(
    elevation: 0,
    mini: true,
    backgroundColor: Colors.redAccent[700],
    child: Icon(
      Icons.edit,
      size: 16.0,
      color: Colors.white,
    ),
    onPressed: () {});
