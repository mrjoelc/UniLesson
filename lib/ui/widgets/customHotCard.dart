import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomHotCard extends StatelessWidget {
  final String cdl;
  CustomHotCard(this.cdl);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
        height: _height / 4.5,
        width: _width,
        margin: EdgeInsets.only(top: 35, left: 10, right: 10),
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
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 15),
                          child: new Text(
                            'Hot Topics',
                            style: TextStyle(fontSize: 23),
                          )),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding: EdgeInsets.only(left: 15, right: 5),
                              child: Text(
                                'in $cdl',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10),
                              ))),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding:
                                  EdgeInsets.only(left: 15, top: 10, right: 10),
                              child: Text(
                                '#Fisica Matematica I ',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, right: 10),
                              child: Text(
                                '#Sistemi_operativi ',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, right: 10),
                              child: Text(
                                '#Analisi III',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, right: 10),
                              child: Text(
                                '#Architettura_degli_elaboratori',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      new Expanded(
                          flex: 0,
                          child: new Padding(
                              padding:
                                  EdgeInsets.only(left: 15, top: 5, right: 10),
                              child: Text(
                                '#Internet_security',
                                overflow: TextOverflow.ellipsis,
                              )))
                    ]))));
  }
}
