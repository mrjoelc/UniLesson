import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/ui/widgets/custom_card_student.dart';
import 'package:unilesson_admin/ui/widgets/custom_card_teacher.dart';

class LessonsList extends StatefulWidget {
  final FirebaseUser user;
  final Function() notifyParent;
  LessonsList(Key key, this.user, this.notifyParent) : super(key: key);

  @override
  _SearchList createState() => new _SearchList();
}

class _SearchList extends State<LessonsList> {
  Algolia algolia = Application.algolia;

  refresh() {
     Timer(const Duration(milliseconds: 1000), () {
        widget.notifyParent();
     });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<AlgoliaObjectSnapshot>> _getData() async {
    AlgoliaQuery query =
        algolia.instance.index('lessons').search(widget.user.uid);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> data = snap.hits;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
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
          } else if (snapshot.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                  child: Text(
                'Nessuna lezione presente :(',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              )),
            );
          } else {
            return Column(
                // scrollDirection: Axis.vertical,
                // shrinkWrap: true,
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
                      // print(snapshot.data["lessonID"]);
                      // return Text(snapshot.data["lessonID"]);
                      //return Text(snapshot.data["profilePictureURL"]);
                      if(snapshot.data.data==null) return Text('');
                      
                      else return CustomCardTeacher(
                        notifyParent: refresh,
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
                      );
                    },
                  );
                }).toList());
          }
        },
      ),
    );

    //   return Column(
    //     children: snapshot.data.map<Widget>((data) {
    //       return new CustomCard(
    //           notifyParent: refresh,
    //           lessonID: data.data["lessonID"],
    //           bannerURL: data.data["bannerPictureURL"],
    //           userURL: data.data["profilePictureURL"],
    //           nameUser: data.data["name"] + ' ' + data.data["surname"],
    //           citta: data.data["citta"],
    //           provincia: data.data["provincia"],
    //           rank: data.data["rank"].toString(),
    //           number: data.data["number"],
    //           description: data.data["description"],
    //           email: data.data["email"],);
    //     }).toList(),
    //   );
  }
}
