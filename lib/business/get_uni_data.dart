import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UniData {
  List<DropdownMenuItem<String>> cdlD = [
    DropdownMenuItem(
      value: "Scienze umanistiche",
      child: Text("Scienze umanistiche"),
    ),
    DropdownMenuItem(
      value: "Medicina clinica e sperimentale",
      child: Text("Medicina clinica e sperimentale"),
    ),
    DropdownMenuItem(
      value: "Ingegneria elettrica, elettronica e informatica",
      child: Text("Ingegneria elettrica, elettronica e informatica"),
    ),
    DropdownMenuItem(
      value: "Scienze mediche, chirurgiche e tecnologie avanzate",
      child: Text("Scienze mediche, chirurgiche e tecnologie avanzate"),
    ),
    DropdownMenuItem(
      value: "Chirurgia generale e specialità medico-chirurgiche",
      child: Text("Chirurgia generale e specialità medico-chirurgiche"),
    ),
    DropdownMenuItem(
      value: "Fisica e Astronomia",
      child: Text("Fisica e Astronomia"),
    ),
    DropdownMenuItem(
      value: "Matematica e Informatica",
      child: Text("Matematica e Informatica"),
    ),
    DropdownMenuItem(
      value: "Economia e Impresa",
      child: Text("Economia e Impresa"),
    ),
    DropdownMenuItem(
      value: "Giurisprudenza",
      child: Text("Giurisprudenza"),
    ),
    DropdownMenuItem(
      value: "Ingegneria civile e Architettura",
      child: Text("Ingegneria civile e Architettura"),
    ),
     DropdownMenuItem(
      value: "Agricoltura, Alimentazione e Ambiente",
      child: Text("Agricoltura, Alimentazione e Ambiente"),
    ),
    DropdownMenuItem(
      value: "Scienze chimiche",
      child: Text("Scienze chimiche"),
    ),
     DropdownMenuItem(
      value: "Scienze del Farmaco",
      child: Text("Scienze del Farmaco"),
    ),
    DropdownMenuItem(
      value: "Scienze biomediche e biotecnologiche",
      child: Text("Scienze biomediche e biotecnologiche"),
    ),
     DropdownMenuItem(
      value: "Scienze politiche e sociali",
      child: Text("Scienze politiche e sociali"),
    ),
    DropdownMenuItem(
      value: "Scienze biologiche, geologiche e ambientali",
      child: Text("Scienze biologiche, geologiche e ambientali"),
    ),
    DropdownMenuItem(
      value: "Lingue e Letterature straniere",
      child: Text("Lingue e Letterature straniere"),
    ),
    DropdownMenuItem(
      value: "Scienze della Formazione",
      child: Text("Scienze della Formazione"),
    ),
  ];
 
 List<DropdownMenuItem<String>> uniD = [
   DropdownMenuItem(
      value: "Università degli Studi di Catania",
      child: Text("Università degli Studi di Catania"),
    ),
     DropdownMenuItem(
      value: "Università Kore di Enna",
      child: Text("Università Kore di Enna"),
    ),
    DropdownMenuItem(
      value: "Università degli Studi di Messina",
      child: Text("Università degli Studi di Messina"),
    ),
    DropdownMenuItem(
      value: "Università degli Studi di Palermo",
      child: Text("Università degli Studi di Palermo"),
    )
 ];

  // Future<List<DropdownMenuItem<String>>> cdlDrop() async {
  //   final documents =
  //       await Firestore.instance.collection('courses').getDocuments();
  //   final userObject = documents.documents;
  //   userObject.forEach((doc) => cdlD.add(doc['dipAppart']));
  //   return cdlD
  //       .map((value) => DropdownMenuItem(
  //             value: value,
  //             child: Text(value),
  //           ))
  //       .toList();
  // }

  // Future<List<DropdownMenuItem<String>>> uniDrop() async {
  //   final documents =
  //       await Firestore.instance.collection('university').getDocuments();
  //   final userObject = documents.documents;
  //   userObject.forEach((doc) => uniD.add(doc['nomeUni']));
  //   return uniD
  //       .map((value) => DropdownMenuItem(
  //             value: value,
  //             child: Text(value),
  //           ))
  //       .toList();
  // }
}
