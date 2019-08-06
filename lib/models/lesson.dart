import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String userID;
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
  final double lat;
  final double lgt;
  final String citta;
  final String regione;
  final String provincia;

  Lesson(
      {this.lessonID,
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
      this.lat,
      this.lgt,
      this.citta,
      this.provincia,
      this.regione,
      this.rank,
      this.userID});

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'lessonID': lessonID,
      'name': name,
      'surname': surname,
      'university': university,
      'cdl': cdl,
      'email': email,
      'profilePictureURL': profilePictureURL,
      'bannerPictureURL': bannerPictureURL,
      'number': number,
      'appIdentifier': 'unilessonAdmin',
      'description': description,
      'tags': tags,
      'regione': regione,
      'provincia': provincia,
      'citta': citta,
      '_geoloc': {
        'lat': lat,
        'lng': lgt,
      },
      'rank': rank
    };
  }

  factory Lesson.fromJson(Map<String, Object> doc) {
    Lesson lesson = new Lesson(
      userID: doc['userID'],
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
      regione: doc['regione'],
      provincia: doc['provincia'],
      citta: doc['citta'],
      lat: doc['lat'],
      lgt: doc['lgt'],
    );
    return lesson;
  }

  factory Lesson.fromDocument(DocumentSnapshot doc) {
    return Lesson.fromJson(doc.data);
  }
}
