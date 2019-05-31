import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userID;
  final String name;
  final String surname;
  final String university;
  final String cdl;
  final String email;
  final String profilePictureURL;
  final String number;

  User({
    this.userID,
    this.name,
    this.surname,
    this.university,
    this.cdl,
    this.email,
    this.profilePictureURL, 
    this.number,
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'name': name,
      'surname' : surname,
      'university': university,
      'cdl': cdl,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'number': number,
      'appIdentifier': 'unilessonAdmin'
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userID: doc['userID'],
      name: doc['name'],
      surname: doc['surname'],
      university: doc['university'],
      cdl: doc['cdl'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
      number: doc['number'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
