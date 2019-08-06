import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unilesson_admin/business/algolia.dart';

class CustomCardStudent extends StatefulWidget {
  final String lessonID;
  final String description;
  final String bannerURL;
  final String userURL;
  final String nameUser;
  final String citta;
  final String provincia;
  final String rank;
  final String number;
  final String email;
  bool favorite = false;
  bool ranked = false;
  bool isFavCard;

  CustomCardStudent(
      {this.lessonID,
      this.bannerURL,
      this.userURL,
      this.nameUser,
      this.citta,
      this.provincia,
      this.rank,
      this.description,
      this.number,
      this.email,
      this.isFavCard});

  Map<String, Object> toJson() {
    return {
      'lessonID': lessonID,
      'bannerURL': bannerURL,
      'userURL': userURL,
      'nameUser': nameUser,
      'citta': citta,
      'provincia': provincia,
      'rank': rank,
      'favorite': favorite,
      'description': description,
      'number': number,
      'email': email,
    };
  }

  factory CustomCardStudent.fromJson(Map<String, Object> doc) {
    CustomCardStudent cc = new CustomCardStudent(
      lessonID: doc['lessonID'],
      bannerURL: doc['bannerURL'],
      userURL: doc['userURL'],
      nameUser: doc['nameUser'],
      citta: doc['citta'],
      provincia: doc['provincia'],
      rank: doc['rank'],
      description: doc['description'],
      email: doc['email'],
      number: doc['number'],
      
    );
    return cc;
  }

  factory CustomCardStudent.fromDocument(DocumentSnapshot doc) {
    return CustomCardStudent.fromJson(doc.data);
  }

  @override
  _CustomCard createState() => new _CustomCard();
}

class _CustomCard extends State<CustomCardStudent> {
  int rank = 0;

  @override
  Widget build(BuildContext context) {
    _isRanked();
    _isFavorite();
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _blockSize = _width / 100;
    final _blockSizeVertical = _height / 100;
    //int fRank = widget.isFavCard ? int.parse(widget.rank) : int.parse(widget.rank)+rank;
    int fRank =int.parse(widget.rank);
    return new Container(
        //height: _blockSizeVertical * 36,
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
            height: _blockSizeVertical * 29,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0)),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(widget.bannerURL))),
          ),
          ExpansionTile(
            trailing: Icon(
              Icons.edit,
              size: 0,
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 5, left: 0, right: 5),
                    child: new CircleAvatar(
                      backgroundImage: NetworkImage(widget.userURL),
                      radius: _height / 27,
                    ),
                  ),
                  new Container(
                    width: _width / 3,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          widget.nameUser,
                          style: TextStyle(fontSize: 14),
                        ),
                        new Text(
                          widget.citta + ", " + widget.provincia,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  new Icon(Icons.star,
                      color: Colors.amber, size: _blockSize * 7),
                  new Text('${fRank<=0 ? fRank=0 : fRank}', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Descrizione',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(widget.description)),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        'Contatti',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomRight,
                            //color: Colors.blue,
                            width: _blockSize * 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        size: 20,
                                      ),
                                      Text(' ' + widget.number),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.alternate_email,
                                        size: 20,
                                      ),
                                      Text(' ' + widget.email),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            // color: Colors.blue,
                            width: _blockSize * 13,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: (widget.favorite || widget.isFavCard
                                      ? Icon(
                                          Icons.favorite,
                                          size: _blockSize * 6,
                                        )
                                      : Icon(Icons.favorite_border,
                                          size: _blockSize * 6)),
                                  color: Colors.red[500],
                                  onPressed: _toggleFavorite,
                                ),
                                IconButton(
                                    icon: (widget.ranked
                                        ? Icon(
                                            Icons.star,
                                            size: _blockSize * 6,
                                          )
                                        : Icon(Icons.star_border,
                                            size: _blockSize * 6)),
                                    color: Colors.amber,
                                    onPressed: _toggleRank)
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ]));
  }

  Future _isFavorite() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .document("users/${user.uid}/favorites/${widget.lessonID}")
        .get()
        .then((doc) {
      if (doc.exists)
        setState(() {
          widget.favorite = true;
        });
      else
        setState(() {
          widget.favorite = false;
        });
    });
  }

  Future _toggleFavorite() async {
    if (widget.favorite) {
      setState(() {
        widget.favorite = false;
      });
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance
          .document("users/${user.uid}/favorites/${widget.lessonID}")
          .delete()
          .catchError((e) {
        print(e);
      });
    } else {
      setState(() {
        widget.favorite = true;
      });
      
      _isRanked();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance
          .document("users/${user.uid}/favorites/${widget.lessonID}")
          .setData({
        'lessonID': widget.lessonID,
      }).catchError((e) {
        print(e);
      });
    }
  }

  Future _isRanked() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .document("users/${user.uid}/ranked/${widget.lessonID}")
        .get()
        .then((doc) {
      if (doc.exists)
        setState(() {
          widget.ranked = true;
        });
      else
        setState(() {
          widget.ranked = false;
        });
    });
  }

  Future _toggleRank() async {
    Algolia algolia = Application.algolia;

    //togli stella
    if (widget.ranked) {
      setState(() {
        widget.ranked = false;
        //if(!widget.isFavCard) rank--;
      });
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance
          .document("users/${user.uid}/ranked/${widget.lessonID}")
          .delete()
          .catchError((e) {
        print(e);
      });
      Firestore.instance.document("lessons/${widget.lessonID}").updateData(
          {'rank': ((int.parse(widget.rank) - 1) <= 0 ? 0 : int.parse(widget.rank) - 1).toString()}).catchError((e) {
        print(e);
      });

      //togli stella
      //algolia
      AlgoliaQuery query =
          algolia.instance.index('lessons').search(widget.lessonID);
      AlgoliaQuerySnapshot snap = await query.getObjects();
      AlgoliaObjectSnapshot obj = await algolia.instance
          .index('lessons')
          .object(snap.hits.first.objectID)
          .getObject();
      //print(obj.objectID);
      // ******* S P E R I M E N T A L E ******* //
      String url =
          'https://5OMLOSI7W8-dsn.algolia.net/1/indexes/lessons/${obj.objectID}/partial';
      //print(url);
      Map<String, dynamic> updateData = Map<String, dynamic>.from(obj.data);
      updateData['rank'] = (int.parse(widget.rank)) <= 0 ? 0 : int.parse(widget.rank)-1;
      await post(
        url,
        headers: _header,
        body:
            utf8.encode(json.encode(updateData, toEncodable: jsonEncodeHelper)),
        encoding: Encoding.getByName('utf-8'),
      );
      // ******* S P E R I M E N T A L E ******* //
    } else {
      //metti stella
      setState(() {
        widget.ranked = true;
        //if(!widget.isFavCard) rank+=1;
      });
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance
          .document("users/${user.uid}/ranked/${widget.lessonID}")
          .setData({"ranked": 'true'}).catchError((e) {
        print(e);
      });
      Firestore.instance.document("lessons/${widget.lessonID}").updateData(
          {'rank': (int.parse(widget.rank) + 1).toString()}).catchError((e) {
        print(e);
      });

      //algolia
      AlgoliaQuery query =
          algolia.instance.index('lessons').search(widget.lessonID);
      AlgoliaQuerySnapshot snap = await query.getObjects();
      AlgoliaObjectSnapshot obj = await algolia.instance
          .index('lessons')
          .object(snap.hits.first.objectID)
          .getObject();
      //print(obj.objectID);
      //metti stella
      // ******* S P E R I M E N T A L E ******* //
      String url =
          'https://5OMLOSI7W8-dsn.algolia.net/1/indexes/lessons/${obj.objectID}/partial';
      //print(url);
      Map<String, dynamic> updateData = Map<String, dynamic>.from(obj.data);
      updateData['rank'] = int.parse(widget.rank) +1;
      await post(
        url,
        headers: _header,
        body:
            utf8.encode(json.encode(updateData, toEncodable: jsonEncodeHelper)),
        encoding: Encoding.getByName('utf-8'),
      );
      // ******* S P E R I M E N T A L E ******* //
    }
  }

  Map<String, String> get _header {
    Map<String, String> map = {
      "X-Algolia-Application-Id": '5OMLOSI7W8',
      "X-Algolia-API-Key": 'd48e039758545a43de350f2a8c187bb9',
      "Content-Type": "application/json",
    };
    return map;
  }
}
