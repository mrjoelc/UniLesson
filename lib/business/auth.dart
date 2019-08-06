import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:flutter/services.dart';
import 'package:algolia/algolia.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Future<String> signIn(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static void addUser(User user) async {
    checkUserExist(user.userID).then((value) async {
      Algolia algolia = Application.algolia;
      AlgoliaTask taskAdded;
      if (!value) {
        print("user ${user.name} ${user.email} added");
        Firestore.instance
            .document("users/${user.userID}")
            .setData(user.toJson());
        taskAdded =
            await algolia.instance.index('users').addObject(user.toJson());
        print('user aggiunto ad algolia: ' + taskAdded.data.toString());
      } else {
        print("user ${user.name} ${user.email} exists");
      }
    });
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Stream<User> getUser(String userID) {
    return Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  static Stream<String> getRole(String userID) {
    var a = Firestore.instance
        .collection("users")
        .where("userID", isEqualTo: userID)
        .snapshots();
    return a.map((doc)  {
         return doc.documents.map((doc) {
         return User.fromDocument(doc).role;
      }).first;
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      print(e.message);
      switch (e.message) {
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          return 'Utente con questa email non trovato.';
          break;
        case "The password is invalid or the user does not have a password.":
          return 'Passowrd non corretta, riprovare.';
          break;
        case "Network error (such as timeout, interrupted connection or unreachable host) has occurred.":
          return 'Un errore di rete (timeout, connessione persa, host irragiungibile).';
          break;
        case "L'email scelta è gia usata da un altro utente per un altro account.":
          return 'Email già presente nel database.';
          break;
        default:
          return 'Errore sconosciuto';
      }
    } else {
      return 'Errore sconosciuto.';
    }
  }
}
