import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/gamebloc.dart';
import 'package:tictactoe/gameboard/game_board.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameBloc _gameBloc;

  @override
  void initState() {
    _gameBloc = GameBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                _gameBloc.dispatch(OnReset());
              },
              child: Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              )),
        ],
        title: Text("Tic Tac Toe"),
      ),
      body: BlocProvider(
        bloc: _gameBloc,
        child: GameBoardWidget(),
      ),
    );
  }
}
