import 'package:flutter/material.dart';

class FavoriteWidget extends StatefulWidget {
  bool _isFavorited;
  
  FavoriteWidget(this._isFavorited);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  // ···
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _blockSize = _width / 100;
    final _blockSizeVertical = _height / 100;
    return Container(
      //margin: EdgeInsets.only(bottom:_blockSize * 2),
      child: IconButton(
        icon: (widget._isFavorited
            ? Icon(
                Icons.favorite,
                size: _blockSize * 8,
              )
            : Icon(Icons.favorite_border, size: _blockSize * 7)),
        color: Colors.red[500],
        onPressed: _toggleFavorite,
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (widget._isFavorited) {
        widget._isFavorited = false;
      } else {
        widget._isFavorited = true;
      }
    });
  }
}
