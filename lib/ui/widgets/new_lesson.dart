import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/business/lessonManager.dart';
import 'package:unilesson_admin/models/lesson.dart';
import "package:unilesson_admin/ui/widgets/custom_text_field.dart";
import 'package:unilesson_admin/business/validator.dart';
import 'package:flutter/services.dart';
import 'package:unilesson_admin/models/user.dart';
import 'package:unilesson_admin/ui/widgets/custom_flat_button.dart';
import 'package:unilesson_admin/ui/widgets/custom_dropdownMenu.dart';
import 'package:unilesson_admin/ui/widgets/custom_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unilesson_admin/business/get_uni_data.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';

class NewLessonPage extends StatefulWidget {
  final FirebaseUser user;
  NewLessonPage(this.user);

  _NewLessonPage createState() => _NewLessonPage();
}

const kGoogleApiKey = "AIzaSyDkG2SqkiXXajr1PZTswYaPq6J0tmZjzWM";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class _NewLessonPage extends State<NewLessonPage> {
  final TextEditingController _description = new TextEditingController();
  final TextEditingController _tags = new TextEditingController();
  CustomTextField _descriptionField;
  CustomTextField _tagsField;
  File _image;
  String downloadURL;
  bool _blackVisible = false;
  VoidCallback onBackPress;
  VoidCallback onBackPress1;
  double lat;
  double lng;
  String citta;
  String regione;
  String provincia;

  @override
  initState() {
    super.initState();
    onBackPress = () {
      Navigator.of(context).pop();
    };

    _descriptionField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _description,
      hint: "Descrizione",
      maxLines: 7,
    );

    _tagsField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _tags,
      hint: "Tags",
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _blockSize = _width / 100;
    final _blockSizeVertical = _height / 100;

    return Stack(alignment: Alignment.topLeft, children: <Widget>[
      ListView(children: <Widget>[
        new Container(
            width: _width,
            margin:
                EdgeInsets.only(bottom: 12.5, top: 12.5, left: 25, right: 25),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  )
                ]),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: new GestureDetector(
                      onTap: () {
                        imageSelectorGallery();
                      },
                      child: Container(
                          height: _blockSizeVertical * 27,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.grey[400]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: _image == null
                                      ? new AssetImage(
                                          'assets/img/cardBase1.jpeg')
                                      : new FileImage(_image))))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: _descriptionField,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: _tagsField,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 18.0, right: 18.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(
                        color: Colors.grey[400],
                        width: 0.5,
                      ),
                    ),
                    onPressed: () async {
                      Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.overlay, // Mode.fullscreen
                          language: "it",
                          logo: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Image.asset(
                                      'assets/img/google_white.png',
                                      scale: 4,
                                    ))
                              ]),
                          hint: "Cerca",
                          components: [new Component(Component.country, "it")]);
                      displayPrediction(p);
                    },
                    child: Container(
                      width: _blockSize * 100,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Text(
                        (citta == null && provincia == null && regione == null)
                            ? 'Seleziona località'
                            : '$citta, $provincia, $regione',
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          color: (citta == null &&
                                  provincia == null &&
                                  regione == null)
                              ? Colors.grey
                              : Colors.black87,
                          fontSize: 16,
                          fontWeight: (citta == null &&
                                  provincia == null &&
                                  regione == null)
                              ? FontWeight.w300
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: Text("Completa tutti i campi",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40.0),
                  child: CustomFlatButton(
                    title: "Inserisci",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    textColor: Colors.white,
                    onPressed: () {
                      _insert(description: _description.text, tags: _tags.text);
                    },
                    splashColor: Colors.black12,
                    borderColor: Colors.redAccent[700],
                    borderWidth: 0,
                    color: Colors.redAccent[700],
                  ),
                ),
              ],
            )),
      ]),
      Offstage(
          offstage: !_blackVisible,
          child: GestureDetector(
            onTap: () {},
            child: AnimatedOpacity(
              opacity: _blackVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
              ),
            ),
          ))
    ]);
  }

  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }

  imageSelectorGallery() async {
    _image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print("Immagine selezionata : " + _image.path);
    setState(() {});
  }

  void _insert({String description, String tags, BuildContext context}) async {
    if (Validator.validateDescription(description) &&
        Validator.validateTags(tags) &&
        Validator.validateImg(_image) &&
        citta != null &&
        provincia != null &&
        regione != null) 
    {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _changeBlackVisible();
        var newDoc = Firestore.instance.collection('lessons').document();
        downloadURL = await uploadImage(_image, newDoc.documentID);
        LessonManager.addNewLesson(
                        newDoc, 
                        widget.user.uid, 
                        downloadURL,
                        description, 
                        tags, 
                        citta, 
                        provincia, 
                        regione, 
                        lat, 
                        lng);
        _showAlert(title: 'Lezione aggiunta', content : "La nuova lezione è stata aggiunta all'elenco delle tue lezioni.", onPressed: onBackPress);
        _changeBlackVisible();
      } catch (e) {
        print("Errore nell'inserimento");
        _showAlert(
          title: "Inserimento fallito",
          onPressed: _changeBlackVisible,
        );
      }
    }
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId, language: 'it');

      lat = detail.result.geometry.location.lat;
      lng = detail.result.geometry.location.lng;

      List<AddressComponent> ac = detail.result.addressComponents;

      for (AddressComponent i in ac) {
        if (i.types[0].toString() == "administrative_area_level_2")
          setState(() {
            provincia = i.shortName;
          });
        if (i.types[0].toString() == "administrative_area_level_1")
          setState(() {
            regione = i.shortName;
          });
      }
      setState(() {
        citta = detail.result.name;
        lat = detail.result.geometry.location.lat;
        lng = detail.result.geometry.location.lng;
      });

      print(regione);
      print(provincia);
      print(citta);
      print(lat);
      print(lng);
    }
  }

  Future<String> uploadImage(var imageFile, String uID) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("lessonImages/" + uID);
    final StorageUploadTask task = firebaseStorageRef.putFile(imageFile);

    StorageTaskSnapshot downloadURL = (await task.onComplete);
    String url = (await downloadURL.ref.getDownloadURL());
    print('URL userProfileImage $url');
    return url;
  }

  void _showAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
}
