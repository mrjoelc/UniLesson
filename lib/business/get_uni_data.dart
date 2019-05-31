import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UniData {
    List<String> cdlD = [];
    List<String> uniD = [];

  Future<List<DropdownMenuItem<String>>> cdlDrop() async {
    final documents =
        await Firestore.instance.collection('courses').getDocuments();
    final userObject = documents.documents;
    userObject.forEach((doc) => cdlD.add(doc['dipAppart']));
    return cdlD
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> uniDrop() async {
    
    final documents =
        await Firestore.instance.collection('university').getDocuments();
    final userObject = documents.documents;
    userObject.forEach((doc) => uniD.add(doc['nomeUni']));
    return uniD
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }
}
