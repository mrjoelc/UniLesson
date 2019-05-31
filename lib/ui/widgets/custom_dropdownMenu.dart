import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final List<DropdownMenuItem<String>> selecteditems;
  String selected;
  final Function validator;

  CustomDropdownMenu(
      {this.hint,
      this.controller,
      this.baseColor,
      this.borderColor,
      this.errorColor,
      this.selecteditems,
      this.selected,
      this.validator});

  _CustomDropdownMenu createState() => _CustomDropdownMenu();
}

class _CustomDropdownMenu extends State<CustomDropdownMenu> {
  Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.symmetric(horizontal: 5.0),
        child: new Container(
            
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5, color: Colors.grey[400]),
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
            ),
            padding: new EdgeInsets.symmetric(horizontal: 10.0),
            child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  isExpanded: true,
                  hint: new Text("${widget.hint}",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w300)),
              iconSize: 0,
              items: widget.selecteditems,
              onChanged: (value) {
                setState(() {
                  widget.selected = value;
                });
              },
              value: widget.selected,
            ))));
  }
}