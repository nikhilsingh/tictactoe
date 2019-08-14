import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tictactoe/model/winnerdata.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  @override
  GameState get initialState => GameInitial(playerTurn: 1);

  @override
  Stream<GameState> mapEventToState(
      GameState currentState, GameEvent event) async* {
    if (event is OnReset) {
      yield GameInitial(playerTurn: 1);
    }

    if (event is OnPlayerTapped) {
      int currentPlayer = event.playerTurn;
      int nextPlayer = currentPlayer == 1 ? 2 : 1;
      List<int> player1List = [];
      List<int> player2List = [];

      if (currentState is GameInitial) {
        player1List.add(event.cellIndex);
      }

      if (currentState is GameInProgress) {
        player1List = currentState.player1ChoiceList;
        player2List = currentState.player2ChoiceList;
        if (event.playerTurn == 1) {
          player1List.add(event.cellIndex);
        } else {
          player2List.add(event.cellIndex);
        }
      }

      WinnerData winnerData = _validateResult(player1List, player2List);

      if (winnerData != null) {
        yield (GameOverWinner(
            winnerPlayer: winnerData.winnerPlayer,
            player1ChoiceList: player1List,
            player2ChoiceList: player2List,
            winnerData: winnerData));
      } else if (player1List.length + player2List.length >= 9) {
        yield (GameOverDraw(
          player1ChoiceList: player1List,
          player2ChoiceList: player2List,
        ));
      } else {
        yield (GameInProgress(
            playerTurn: nextPlayer,
            player1ChoiceList: player1List,
            player2ChoiceList: player2List));
      }

      //yield (GameInProgress());
    }
  } //initial player Turn 1

  WinnerData _validateResult(List<int> player1, List<int> player2) {
    bool isWinner;

    player1.sort();
    player2.sort();

    List<List<int>> winnerComb = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [2, 4, 6],
      [0, 4, 8]
    ];

    for (int i = 0; i < winnerComb.length; i++) {
      int count1 = 0;
      int count2 = 0;
      for (int j = 0; j < winnerComb[i].length; j++) {
        if (player1.contains(winnerComb[i][j])) {
          count1++;
        }
        if (count1 == 3) {
          WinnerData winnerData = WinnerData();
          winnerData.winnerPlayer = 1;
          winnerData.winningComb = winnerComb[i];

          winnerData.winType = getWinningType(winnerComb[i]);

          return winnerData;
        }

        if (player2.contains(winnerComb[i][j])) {
          count2++;
        }
        if (count2 == 3) {
          WinnerData winnerData = WinnerData();
          winnerData.winnerPlayer = 2;
          winnerData.winningComb = winnerComb[i];

          winnerData.winType = getWinningType(winnerComb[i]);
          return winnerData;
        }
      }
    }

    return null;
  }

  List<String> getWinningType(List<int> list) {
    List<String> winType = [];

    switch (list[1] - list[0]) {
      case 1:
        winType.add("H");
        int first = list[0];
        if (first == 0) {
          winType.add("TOP");
        } else if (first == 3) {
          winType.add("MID");
        } else {
          winType.add("BOT");
        }
        //horizontal
        break;
      case 3:
        winType.add("V");
        int first = list[0];
        if (first == 0) {
          winType.add("LEFT");
        } else if (first == 1) {
          winType.add("MID");
        } else {
          winType.add("RIGHT");
        }

        break;
      case 4:
        winType.add("D");
        int first = list[0];
        if (first == 0) {
          winType.add("LEFT");
        }
        break; //diagonol
      case 2:
        winType.add("D");
        int first = list[0];
        if (first == 2) {
          winType.add("RIGHT");
        }
        break; //diagonol
    }
    return winType;
  }

/*  [0, 1, 2], 1
    [3, 4, 5], 1
    [6, 7, 8], 1
    [0, 3, 6], 3
    [1, 4, 7], 3
    [2, 5, 8], 3
    [2, 4, 6], 4
    [0, 4, 8] 4
  
  */

}

@override
Stream<GameEvent> transform(Stream<GameEvent> events) {
  return (events as Observable<GameEvent>)
      .debounce(Duration(milliseconds: 500));
}
/*


***************EVENTS*******************


*/

abstract class GameEvent extends Equatable {
  GameEvent([List props = const []]) : super([props]);
}

class OnPlayerTapped extends GameEvent {
  int cellIndex;
  int playerTurn;

  OnPlayerTapped({this.cellIndex, this.playerTurn}) : super([cellIndex]);
}

class OnReset extends GameEvent {
  @override
  String toString() {
    return 'OnReset{}';
  }
}
/*


***************STATE*****************************


*/

abstract class GameState extends Equatable {
  GameState([List props = const []]) : super([props]);
}

class GameInitial extends GameState {
  final int playerTurn;

  GameInitial({this.playerTurn}) : super([playerTurn]);

  @override
  String toString() {
    return 'GameInitial{}';
  }
}

class GameInProgress extends GameState {
  final int playerTurn;
  final List<int> player1ChoiceList;
  final List<int> player2ChoiceList;

  GameInProgress(
      {this.playerTurn, this.player1ChoiceList, this.player2ChoiceList})
      : super([playerTurn, player1ChoiceList, player2ChoiceList]);

  @override
  String toString() {
    return 'GameInProgress{playerTurn: $playerTurn, player1ChoiceList: $player1ChoiceList, player2ChoiceList: $player2ChoiceList}';
  }
}

class GameOverWinner extends GameState {
  final int winnerPlayer;
  final List<int> player1ChoiceList;
  final List<int> player2ChoiceList;
  final WinnerData winnerData;

  GameOverWinner(
      {this.winnerPlayer,
      this.player1ChoiceList,
      this.player2ChoiceList,
      this.winnerData})
      : super([winnerPlayer, player1ChoiceList, player2ChoiceList, winnerData]);
}

class GameOverDraw extends GameState {
  final List<int> player1ChoiceList;
  final List<int> player2ChoiceList;

  GameOverDraw({this.player1ChoiceList, this.player2ChoiceList})
      : super([player1ChoiceList, player2ChoiceList]);
}
