import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/ui/widgets/custom_card_student.dart';


class SearchScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final String keyword;
  SearchScreen(this.keyword, this.firebaseUser);

  @override
  _SearchScreen createState() => new _SearchScreen();
}



class _SearchScreen extends State<SearchScreen> {
  Algolia algolia = Application.algolia;

  @override
  void initState() {
    super.initState();
  }



  Future<List<AlgoliaObjectSnapshot>> _getData() async {
    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    // print(position);
    AlgoliaQuery query =
        algolia.instance.index('lessons').search(widget.keyword).setAroundLatLngViaIP(true);
    //query = query.setAroundLatLngViaIP(true);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> data = snap.hits;

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white30,
          elevation: 0,
          title: Image(
            image: AssetImage('assets/img/logo.png'),
            width: 50,
          ),
          centerTitle: true,
        ),
        body: new Container(
            child: new FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(212, 20, 15, 1.0),
                  ),
                ),
              );
            } 
            else if(snapshot.data.length == 0) {
                return  Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text('Nessuna lezione presente :(', style: TextStyle(color: Colors.grey, fontSize: 20),)
                  ),
                );
              }
            else {
              return ListView(
                  children: snapshot.data.map<Widget>((obj) {
                // var id = Firestore.instance
                //     .collection('lessons')
                //     .document(obj.data["lessonID"])
                //     .snapshots();
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('lessons')
                      .document(obj.data["lessonID"])
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(212, 20, 15, 1.0),
                          ),
                        ),
                      );
                    return CustomCardStudent(
                        lessonID: snapshot.data["lessonID"],
                        bannerURL: snapshot.data["bannerPictureURL"],
                        userURL: snapshot.data["profilePictureURL"],
                        nameUser:
                            snapshot.data["name"] + ' ' + snapshot.data["surname"],
                        citta: snapshot.data["citta"],
                        provincia: snapshot.data["provincia"],
                        rank: snapshot.data["rank"].toString(),
                        description: snapshot.data["description"],
                        email: snapshot.data["email"],
                        number: snapshot.data["number"],
                        isFavCard: false);
                  },
                );
              }).toList());
            }
          },
        )));
  }

  // void _onItemTapped(int index) {
  //   if (index == 0) Navigator.pop(context);
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }
}
