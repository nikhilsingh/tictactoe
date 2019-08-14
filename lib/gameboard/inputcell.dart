import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/gamebloc.dart';
import 'package:tictactoe/paint/circle.dart';
import 'package:tictactoe/paint/cross.dart';

class InputCellWidget extends StatefulWidget {
  int cellStatus;
  int index;

  InputCellWidget({Key key, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InputCellState();
  }
}

class _InputCellState extends State<InputCellWidget> {
  int cellStatus = 0;
  GameBloc _gameBloc;

  @override
  void initState() {
    _gameBloc = BlocProvider.of<GameBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int cellStatus = 0;
    int playerTurn = 0;
    return BlocBuilder(
        bloc: _gameBloc,
        builder: (context, state) {

          if (state is GameInProgress ) {
            for (int a in state.player1ChoiceList) {
              if (a == widget.index) {
                cellStatus = 1; //PlayerOne
              }
            }

            for (int b in state.player2ChoiceList) {
              if (b == widget.index) {
                cellStatus = 2;
              }
            }

            playerTurn = state.playerTurn;
          }

          if (state is GameInitial) {
            cellStatus = 0;
            playerTurn = 1;
          }

          if(state is GameOverWinner){
            for (int a in state.player1ChoiceList) {
              if (a == widget.index) {
                cellStatus = 1; //PlayerOne
              }
            }

            for (int b in state.player2ChoiceList) {
              if (b == widget.index) {
                cellStatus = 2;
              }
            }
          }

          if(state is GameOverDraw){
            for (int a in state.player1ChoiceList) {
              if (a == widget.index) {
                cellStatus = 1; //PlayerOne
              }
            }

            for (int b in state.player2ChoiceList) {
              if (b == widget.index) {
                cellStatus = 2;
              }
            }
          }

          return GestureDetector(
            onTap: () {

              _gameBloc.dispatch(
                OnPlayerTapped(cellIndex: widget.index, playerTurn: playerTurn),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Center(
                child: _cellStatusWidget(cellStatus),
              ),
            ),
          );
        });
  }

  Widget _cellStatusWidget(int cellStatus) {
    switch (cellStatus) {
      case 0:
        return Container();
        break;
      case 1:
        return CrossWidget();
        break;
      case 2:
        return CircleWidget();
        break;
    }
  }
}
