import 'package:flutter/material.dart';

class BoardSurfaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              color: Colors.cyan,
              width: 6.0,
            ),
            Container(
              color: Colors.cyan,
              width: 6.0,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              color: Colors.cyan,
              height: 6.0,
            ),
            Container(
              color: Colors.cyan,
              height: 6.0,
            )
          ],
        )
      ],
    );
  }
}
