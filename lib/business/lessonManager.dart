import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/models/lesson.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:algolia/algolia.dart';


class LessonManager {

  static void addNewLesson(DocumentReference newDoc, String uid, String downloadURL, String description, String tags, String citta, String provincia, String regione, double lat, double lgt) {
    var user = Auth.getUser(uid);
        
        user.listen((data) {
                    print(downloadURL);
                    newDoc.setData(new Lesson(
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
                            )
                        .toJson());
                  });
  }
}
