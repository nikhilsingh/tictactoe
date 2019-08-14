import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/gamebloc.dart';
import 'package:tictactoe/model/winnerdata.dart';

class WinningLineWidget extends StatefulWidget {
  WinningLineWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WinningLineWidgetState();
}

class WinningLineWidgetState extends State<WinningLineWidget>
    with SingleTickerProviderStateMixin {
  GameBloc _gameBloc;

  Animation<double> animation;
  AnimationController controller;
  double animValue;

  @override
  void initState() {
    _gameBloc = BlocProvider.of<GameBloc>(context);
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          animValue = animation.value;
        });
      });
    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder(
      bloc: _gameBloc,
      builder: (context, state) {
        if (state is GameOverWinner) {
          return CustomPaint(
            size: Size.infinite,
            painter: WinningLinePaint(state.winnerData,animValue),
          );
        } else {
          return Container(
            height: 1.0,
            width: 1.0,
          );
        }
      },
    );
  }
}

class WinningLinePaint extends CustomPainter {
  Paint _paint;
  WinnerData _winnerData;
  double _animValue;



  WinningLinePaint(WinnerData winnerData,double animval) {
    this._winnerData = winnerData;
    _paint = Paint();

    _paint.color = Colors.red;
    _paint.strokeWidth = 4.0;
    _paint.strokeCap = StrokeCap.round;
    _animValue=animval;
  }

  @override
  void paint(Canvas canvas, Size size) {

    if (_winnerData != null) {
      if (_winnerData.winType[0] == "H") {
        _drawHorizontalLine(size, canvas);
      } else if (_winnerData.winType[0] == "V") {
        _drawVerticalLine(size, canvas);
      } else if (_winnerData.winType[0] == "D") {
        _drawDiagonalLine(size, canvas);
      }
    }
  }

  void _drawVerticalLine(Size size, Canvas canvas) {

    String linePosition = _winnerData.winType[1];

    if (linePosition == "LEFT") {
      var x = size.width / 3 / 2;
      var top = Offset(x, 8.0);
      var bottom = Offset(x, size.height - 8.0);
      canvas.drawLine(top, bottom, _paint);
    } else if (linePosition == "MID") {
      var x = size.width / 2;
      var top = Offset(x, 8.0);
      var bottom = Offset(x, size.height - 8.0);
      canvas.drawLine(top, bottom, _paint);
    } else if (linePosition == "RIGHT") {
      var columnWidth = size.width / 3;
      var x = columnWidth * 2 + columnWidth / 2;
      var top = Offset(x, 8.0);
      var bottom = Offset(x, size.height - 8.0);
      canvas.drawLine(top, bottom, _paint);
    }

  }

  void _drawHorizontalLine(Size size, Canvas canvas) {
    String linePosition = _winnerData.winType[1];
    if (linePosition == "TOP") {
      var y = size.height / 3 / 2;
      var left = Offset(8.0, y);
      var right = Offset(size.width - 8.0, y);
      canvas.drawLine(left, right, _paint);
    } else if (linePosition == "MID") {
      var y = size.height / 2;
      var left = Offset(8.0, y);
      var right = Offset(size.width - 8.0, y);
      canvas.drawLine(left, right, _paint);
    } else if (linePosition == "BOT") {
      var columnHeight = size.height / 3;
      var y = columnHeight * 2 + columnHeight / 2;
      var left = Offset(8.0, y);
      var right = Offset(size.width - 8.0, y);
      canvas.drawLine(left, right, _paint);
    }

  }

  void _drawDiagonalLine(Size size, Canvas canvas) {
    String linePosition = _winnerData.winType[1];

    if (linePosition == "RIGHT") {
      var bottomLeft = Offset(8.0, size.height - 8.0);
      var topRight = Offset(size.width - 8.0, 8.0);
      canvas.drawLine(bottomLeft, topRight, _paint);
    } else {
      var topLeft = Offset(8.0, 8.0);
      var bottomRight = Offset(size.width - 8.0, size.height - 8.0);
      canvas.drawLine(topLeft, bottomRight, _paint);
    }
  }

  @override
  bool shouldRepaint(WinningLinePaint oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(WinningLinePaint oldDelegate) => false;
}
