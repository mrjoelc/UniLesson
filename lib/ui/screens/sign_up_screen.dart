import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unilesson_admin/business/auth.dart';
import 'package:unilesson_admin/ui/screens/main_screen_student.dart';
import 'package:unilesson_admin/ui/screens/main_screen_teacher.dart';
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

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
  SharedPreferences prefs;
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _surname = new TextEditingController();
  final TextEditingController _number = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  CustomTextField _nameField;
  CustomTextField _surnameField;
  CustomTextField _phoneField;
  CustomTextField _emailField;
  CustomTextField _passwordField;
  CustomDropdownMenu _universityField;
  CustomDropdownMenu _cdlField;
  CustomDropdownMenu _role;
  List<DropdownMenuItem<String>> role = [
    DropdownMenuItem(
      value: "teacher",
      child: Text("Voglio insegnare"),
    ),
    DropdownMenuItem(
      value: "student",
      child: Text("Voglio imparare"),
    ),
  ];
  File _image;
  String downloadURL;
  bool _blackVisible = false;
  VoidCallback onBackPress;
  UniData uniData = new UniData();

  // _loadCdlField() async {
  //   _cdlField = new CustomDropdownMenu(
  //     hint: "Seleziona dipartimento di appartenza",
  //     selecteditems: await uniData.cdlDrop(),
  //   );
  // }

  // _loadUniField() async {
  //   _universityField = new CustomDropdownMenu(
  //     hint: "Seleziona università",
  //     selecteditems: await uniData.uniDrop(),
  //   );
  // }

  @override
  initState() {
    super.initState();
    onBackPress = () {
      Navigator.of(context).pop();
    };

    _nameField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _name,
      hint: "Nome",
      validator: Validator.validateName,
    );

    _surnameField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _surname,
      hint: "Cognome",
      validator: Validator.validateSurName,
    );

    _phoneField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _number,
      hint: "Numero telefono",
      validator: Validator.validateNumber,
      inputType: TextInputType.number,
    );

    //_loadUniField();
    _universityField = new CustomDropdownMenu(
      hint: "Seleziona università",
      selecteditems: uniData.uniD,
    );

    //_loadCdlField();
    _cdlField = new CustomDropdownMenu(
      hint: "Seleziona dipartimento di appartenza",
      selecteditems: uniData.cdlD,
    );

    _role = new CustomDropdownMenu(
      hint: "Cosa vuoi fare",
      selecteditems: role,
    );

    _emailField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _email,
      hint: "Indirizzo E-mail",
      inputType: TextInputType.emailAddress,
      validator: Validator.validateEmail,
    );

    _passwordField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _password,
      obscureText: true,
      hint: "Password",
      validator: Validator.validatePassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                      child: Text(
                        "Crea un nuovo account",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(212, 20, 15, 1.0),
                          decoration: TextDecoration.none,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: MediaQuery.of(context).size.width/3, right: MediaQuery.of(context).size.width/3),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width/3.5,
                        child: new GestureDetector(
                          onTap: () {
                            imageSelectorGallery();
                          },
                          child: ClipOval(
                              child: _image == null
                                  ? new Image.asset('assets/img/face.png')
                                  : new Image.file(_image,
                                     
                                      fit: BoxFit.fitHeight)),
                        ),
                      ),
                    ),
                     Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      child: _role,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: _nameField,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: _surnameField,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: _phoneField,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: _universityField),
                    Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: _cdlField),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: _emailField,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: _passwordField,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                      child: Text("Completa tutti i campi per registrarti",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[400])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 40.0),
                      child: CustomFlatButton(
                        title: "Registrati",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.white,
                        onPressed: () async {
                          await _signUp(
                                  role: _role.selected,
                                  name: _name.text,
                                  surname: _surname.text,
                                  email: _email.text,
                                  university: _universityField.selected,
                                  cdl: _cdlField.selected,
                                  number: _number.text,
                                  password: _password.text)
                              .then((i) async {
                            if (i) {
                              var user = await Auth.getCurrentFirebaseUser();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        _role.selected=='teacher' ? MainScreenTeacher(firebaseUser: user) : MainScreenStudent(firebaseUser: user,)),
                                (Route<dynamic> route) => false,
                              );
                            }
                          });
                        },
                        splashColor: Colors.black12,
                        borderColor: Colors.redAccent[700],
                        borderWidth: 0,
                        color: Colors.redAccent[700],
                      ),
                    ),
                  ],
                ),
                SafeArea(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: onBackPress,
                  ),
                ),
              ],
            ),
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
              ),
            ),
          ],
        ),
      ),
    );
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

  Future _signUp(
      {
      String role,
      String name,
      String surname,
      String number,
      String university,
      String cdl,
      String email,
      String password,
      BuildContext context}) async {
    if (Validator.validateName(name) &&
        Validator.validateName(surname) &&
        Validator.validateEmail(email) &&
        Validator.validateNumber(number) &&
        Validator.validatePassword(password) &&
        Validator.validateUni(university) &&
        Validator.validateCdl(cdl)) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        widget.prefs = await SharedPreferences.getInstance();

        print("user is: "+ role);

        _changeBlackVisible();
        await Auth.signUp(email, password).then((uID) async {
          _image == null
              ? downloadURL = ''
              : downloadURL = await uploadImage(_image, uID);
          Auth.addUser(new User(
              role: role,
              userID: uID,
              name: name,
              surname: surname,
              university: university,
              cdl: cdl,
              email: email,
              profilePictureURL: downloadURL,
              number: number));
        });
        return true;
      } catch (e) {
        print("Errore nella registrazione: $e");
        String exception = Auth.getExceptionText(e);
        _showErrorAlert(
          title: "Registrazione fallita",
          content: exception,
          onPressed: _changeBlackVisible,
        );
      }
    }
  }

  Future<String> uploadImage(var imageFile, String uID) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("userProfileImages/" + uID);
    final StorageUploadTask task = firebaseStorageRef.putFile(imageFile);

    StorageTaskSnapshot downloadURL = (await task.onComplete);
    String url = (await downloadURL.ref.getDownloadURL());
    print('URL userProfileImage $url');
    return url;
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
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
