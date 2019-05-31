import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unilesson_admin/business/algolia.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:flutter/services.dart';
import 'dart:async';
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
        taskAdded = await algolia.instance.index('users').addObject(user.toJson());
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

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case "Non esiste un utente corrispondente con questo identificativo. L'utente potrebbe essere stato eliminato.":
          return 'Utente con questa email non trovato.';
          break;
        case "La password è invalida o l'utente non ha una passwrod.":
          return 'Passowrd invalida.';
          break;
        case "Un errore di rete (timeout, connessione persa, host irragiungibile).":
          return 'Nessuna connessione internet.';
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
