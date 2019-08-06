import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/models/lesson.dart';
import 'package:algolia/algolia.dart';

class LessonManager {
  static addNewLesson(
      DocumentReference newDoc,
      String uid,
      String downloadURL,
      String description,
      String tags,
      String citta,
      String provincia,
      String regione,
      double lat,
      double lgt) {
    var user = Auth.getUser(uid);
    user.listen((data) async {
      Lesson nl = new Lesson(
        userID: data.userID,
        lessonID: newDoc.documentID,
        name: data.name,
        surname: data.surname,
        university: data.university,
        rank: 0,
        cdl: data.cdl,
        email: data.email,
        profilePictureURL: data.profilePictureURL,
        bannerPictureURL: downloadURL,
        number: data.number,
        description: description,
        tags: tags,
        citta: citta,
        provincia: provincia,
        regione: regione,
        lat: lat,
        lgt: lgt,
      );
      newDoc.setData(nl.toJson());
      Algolia algolia = Application.algolia;
      await algolia.instance.index('lessons').addObject(nl.toJson());
      print('Aggiunta lezione algolia + firestore ' + newDoc.documentID);
    });
  }

  static removeLesson(String lessonID) async {
    Firestore.instance.collection('lessons').document(lessonID).delete().catchError((e){print(e);});
    Algolia algolia = Application.algolia;
    AlgoliaQuery query = algolia.instance.index('lessons').search(lessonID);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    AlgoliaObjectSnapshot obj = await algolia.instance.index('lessons').object(snap.hits.first.objectID).getObject();
    await algolia.instance.index('lessons').object(obj.objectID).deleteObject();
    print('Rimossa lezione algolia + firestore ' + lessonID);


  }
}
