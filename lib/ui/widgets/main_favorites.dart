import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/ui/widgets/custom_card_student.dart';

class MainFavorites extends StatefulWidget {
  final FirebaseUser user;

  MainFavorites(this.user);

  @override
  _MainFavorites createState() => new _MainFavorites();
}

class _MainFavorites extends State<MainFavorites> {
  _getFavorites() async {
    return Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .collection('favorites')
        .snapshots();
  }

  _getData1(String lessonID) async {
    return Firestore.instance.collection('lessons').document(lessonID);
  }

  Future<List<AlgoliaObjectSnapshot>> _getData(String lessonID) async {
    Algolia algolia = Application.algolia;
    AlgoliaQuery query = algolia.instance.index('lessons').search(lessonID);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> data = snap.hits;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(widget.user.uid)
          .collection('favorites')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(212, 20, 15, 1.0),
              ),
            ),
          );
        else if (snapshot.data.documents.length == 0)
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
                child: Text(
              'Nessuna lezione presente :)',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            )),
          );

        return StreamBuilder(
          stream: Firestore.instance.collection('lessons').snapshots(),
          builder: (context, snapshot2) {
            if (!snapshot2.hasData)
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(212, 20, 15, 1.0),
                  ),
                ),
              );
            return ListView(
                children: snapshot.data.documents.map<Widget>((doc) {
              var obj;
              snapshot2.data.documents.map<Widget>((doc2) {
                doc2.documentID == doc.documentID ? obj = doc2 : null;
              }).toList();
              if (obj == null)
                return Text(
                  '',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                );
              else
                return CustomCardStudent(
                  lessonID: obj["lessonID"],
                  bannerURL: obj["bannerPictureURL"],
                  userURL: obj["profilePictureURL"],
                  nameUser: obj["name"] + obj["surname"],
                  citta: obj["citta"],
                  provincia: obj["provincia"],
                  rank: obj["rank"].toString(),
                  description: obj["description"],
                  email: obj["email"],
                  number: obj["number"],
                  isFavCard: true,
                );
            }).toList());
          },
        );
      },
    );
  }
}

// snapshot.data.documents.map(
//           (document) {
//             //_getData1(document['lessonID']);
//             return new Container(child: Text(document['lessonID']),);
//           },
//         );
// return new CustomCard(
//             lessonID: document["lessonID"],
//             bannerURL: document["bannerURL"],
//             userURL: document["userURL"],
//             nameUser: document["nameUser"],
//             citta: document["citta"],
//             regione: document["regione"],
//             rank: document["rank"],
//             description: document["description"],
//             email: document["email"],
//             number: document["number"],
//           );
