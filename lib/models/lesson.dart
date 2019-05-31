import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String lessonID;
  final String name;
  final String surname;
  final String university;
  final String cdl;
  final String email;
  final String profilePictureURL;
  final String number;
  final String description;
  final String tags;
  final String bannerPictureURL;
  final int rank;

  Lesson({
    this.lessonID,
    this.name,
    this.surname,
    this.university,
    this.cdl,
    this.email,
    this.profilePictureURL, 
    this.number,
    this.description,
    this.tags, 
    this.bannerPictureURL,
    this.rank,
  });

  Map<String, Object> toJson() {
    return {
      'lessonID': lessonID,
      'name': name,
      'surname' : surname,
      'university': university,
      'cdl': cdl,
      'email':  email,
      'profilePictureURL': profilePictureURL,
      'bannerPictureURL': bannerPictureURL,
      'number': number,
      'appIdentifier': 'unilessonAdmin',
      'description': description,
      'tags': tags,
      'rank': rank
    };
  }

  factory Lesson.fromJson(Map<String, Object> doc) {
    Lesson lesson = new Lesson(
      lessonID: doc['lessonID'],
      name: doc['name'],
      surname: doc['surname'],
      university: doc['university'],
      cdl: doc['cdl'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
      bannerPictureURL: doc['bannerPictureURL'],
      number: doc['number'],
      description: doc['description'],
      tags: doc['tags'],
      rank: doc['rank'],
    );
    return lesson;
  }

  factory Lesson.fromDocument(DocumentSnapshot doc) {
    return Lesson.fromJson(doc.data);
  }
}
