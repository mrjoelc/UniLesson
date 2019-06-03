import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilesson_admin/ui/widgets/trash.dart';

class CustomCard extends StatefulWidget {
  final String lessonID;
  final String bannerURL;
  final String userURL;
  final String nameUser;
  final String citta;
  final String regione;
  final String rank;
  bool favorite = false;

  CustomCard(
      {this.lessonID,
      this.bannerURL,
      this.userURL,
      this.nameUser,
      this.citta,
      this.regione,
      this.rank});

  Map<String, Object> toJson() {
    return {
      'lessonID' : lessonID,
      'bannerURL': bannerURL,
      'userURL': userURL,
      'nameUser': nameUser,
      'citta': citta,
      'regione': regione,
      'rank': rank,
      'favorite': favorite,
    };
  }

  factory CustomCard.fromJson(Map<String, Object> doc) {
    CustomCard cc = new CustomCard(
      lessonID: doc['lessonID'],
      bannerURL: doc['bannerURL'],
      userURL: doc['userURL'],
      nameUser: doc['nameUser'],
      citta: doc['citta'],
      regione: doc['regione'],
      rank: doc['rank'],
    );
    return cc;
  }

  factory CustomCard.fromDocument(DocumentSnapshot doc) {
    return CustomCard.fromJson(doc.data);
  }

  @override
  _CustomCard createState() => new _CustomCard();
}

class _CustomCard extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _blockSize = _width / 100;
    final _blockSizeVertical = _height / 100;

    return new Container(
        height: _blockSizeVertical *31,
        width: _width,
        margin: EdgeInsets.only(bottom: 12.5, top: 12.5, left: 25, right: 25),
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
        child: new Column(children: <Widget>[
          Container(
            height: _blockSizeVertical * 22,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0)),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(widget.bannerURL))),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 5, left: 10, right: 5),
                child: new CircleAvatar(
                  backgroundImage: NetworkImage(widget.userURL),
                  radius: _height / 27,
                ),
              ),
              new Container(
                width: _width / 2.7,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      widget.nameUser,
                      style: TextStyle(fontSize: 14),
                    ),
                    new Text(
                      widget.citta + ", " + widget.regione,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              new Icon(Icons.star, color: Colors.amber, size: _blockSize * 7),
              new Text('${widget.rank}', style: TextStyle(fontSize: 14)),
              TrashButton(widget.lessonID),
            ],
          ),
        ]));
  }
}
