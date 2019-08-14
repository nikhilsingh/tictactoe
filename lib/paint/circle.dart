import 'dart:math';

import 'package:flutter/material.dart';

class CircleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CircleWidgetState();
  }
}

class _CircleWidgetState extends State<CircleWidget>
    with SingleTickerProviderStateMixin {
  CirclePainter painter;
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    painter = CirclePainter(fraction);
    return CustomPaint(
      size: Size.infinite,
      painter: painter,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CirclePainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    var rect = Offset(5.0, 5.0) & Size(size.width - 10.0, size.height - 10.0);
    canvas.drawArc(rect, -pi / 2, pi * 2 * _fraction, false, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
