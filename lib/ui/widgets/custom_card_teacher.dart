import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilesson_admin/ui/widgets/trash.dart';

class CustomCardTeacher extends StatefulWidget {
  final String lessonID;
  final String bannerURL;
  final String userURL;
  final String nameUser;
  final String citta;
  final String provincia;
  final String rank;
  final String description;
  final String number;
  final String email;
  bool favorite = false;
  final Function() notifyParent;

  CustomCardTeacher(
      {Key key,
      this.notifyParent,
      this.lessonID,
      this.bannerURL,
      this.userURL,
      this.nameUser,
      this.citta,
      this.provincia,
      this.rank,
      this.description,
      this.number,
      this.email})
      : super(key: key);

  Map<String, Object> toJson() {
    return {
      'notifyParent': notifyParent,
      'lessonID': lessonID,
      'bannerURL': bannerURL,
      'userURL': userURL,
      'nameUser': nameUser,
      'citta': citta,
      'provincia': provincia,
      'rank': rank,
      'favorite': favorite,
      'description': description,
      'number': number,
      'email': email,
    };
  }

  factory CustomCardTeacher.fromJson(Map<String, Object> doc) {
    CustomCardTeacher cc = new CustomCardTeacher(
      notifyParent: doc['notifyParent'],
      lessonID: doc['lessonID'],
      bannerURL: doc['bannerURL'],
      userURL: doc['userURL'],
      nameUser: doc['nameUser'],
      citta: doc['citta'],
      provincia: doc['provincia'],
      rank: doc['rank'],
      description: doc['description'],
      email: doc['email'],
      number: doc['number'],
    );
    return cc;
  }

  factory CustomCardTeacher.fromDocument(DocumentSnapshot doc) {
    return CustomCardTeacher.fromJson(doc.data);
  }

  @override
  _CustomCard createState() => new _CustomCard();
}

class _CustomCard extends State<CustomCardTeacher> {
  refresh() {
    setState(() {
      widget.notifyParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _blockSize = _width / 100;
    final _blockSizeVertical = _height / 100;

    return new Container(
        //height: _blockSizeVertical * 36,
        width: _width,
        margin: EdgeInsets.only(bottom: 12.5, top: 12.5, left: 25, right: 25),
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
        child: new Column(children: <Widget>[
          Container(
            height: _blockSizeVertical * 29,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0)),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(widget.bannerURL))),
          ),
          ExpansionTile(
            trailing: Icon(
              Icons.edit,
              size: 0,
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 5, left: 0, right: 5),
                    child: new CircleAvatar(
                      backgroundImage: NetworkImage(widget.userURL),
                      radius: _height / 27,
                    ),
                  ),
                  new Container(
                    width: _width / 3,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          widget.nameUser,
                          style: TextStyle(fontSize: 14),
                        ),
                        new Text(
                          widget.citta + ", " + widget.provincia,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  new Icon(Icons.star,
                      color: Colors.amber, size: _blockSize * 6),
                  new Text('${int.parse(widget.rank) <= 0 ? 0 : widget.rank}', style: TextStyle(fontSize: 14)),
                  //TrashButton(UniqueKey(), widget.lessonID, refresh),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Descrizione',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(widget.description)),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Text(
                        'Contatti',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomRight,
                            //color: Colors.blue,
                            width: _blockSize * 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        size: 20,
                                      ),
                                      Text(' ' + widget.number),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.alternate_email,
                                        size: 20,
                                      ),
                                      Text(' ' + widget.email),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              TrashButton(UniqueKey(), widget.lessonID, refresh),
            ],
          ),
        ]));
  }
}
