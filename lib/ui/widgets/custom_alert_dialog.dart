import 'package:flutter/material.dart';
import 'package:unilesson_admin/ui/widgets/custom_flat_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  CustomAlertDialog({this.title, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          contentPadding: EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0))),
          title: Text(
            title,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "OpenSans",
            ),
          ),
          content: Container(
            padding: EdgeInsets.only(left: 10,right:10),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  content,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomFlatButton(
                    title: "Ho capito",
                    fontSize: 14,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.black12,
                    borderColor: Colors.redAccent[700],
                    borderWidth: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
  }
}