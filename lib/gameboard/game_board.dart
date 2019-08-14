import 'package:flutter/material.dart';
import 'package:tictactoe/bloc/gamebloc.dart';
import 'board_surface.dart';
import 'inputcell.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'winning_line.dart';

class GameBoardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GameBoardState();
  }
}

class _GameBoardState extends State<GameBoardWidget> {
  GameBloc _gameBloc;
  @override
  void initState() {
    _gameBloc=BlocProvider.of<GameBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(color: Colors.white,

          child: Stack(
            children: <Widget>[
              AspectRatio(aspectRatio: 1.0, child: BoardSurfaceWidget()),
              AspectRatio(aspectRatio: 1.0, child: _inputCellGrid()),
            AspectRatio(aspectRatio:1.0,child: WinningLineWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputCellGrid() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (index) {
        return Center(
          child: InputCellWidget(
            index: index,
          ),
        );
      }),
    );
  }
}
