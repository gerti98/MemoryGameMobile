import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'Board.dart';
import 'dart:async';

Board board = new Board(8);

class BoardWidget extends StatefulWidget {
  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Board board;
  double cardHeightPercentage, cardWidthPercentage;
  List<bool> isCard;
  List<bool> isFlippedCard;
  int numFlippedCards;
  int lastFlipped;

  @override
  void initState() {
    super.initState();
    print("Init state board");
    initBoardData(8);
  }

  void initBoardData(int num) {
    if (num <= 8) {
      cardHeightPercentage = 0.11;
      cardWidthPercentage = 0.18;
    } else {
      cardHeightPercentage = 0.1;
      cardWidthPercentage = 0.1;
    }

    isCard = List.filled(16, true);
    isFlippedCard = List.filled(16, false);
    numFlippedCards = 0;
    lastFlipped = -1;

    board = new Board(num);
    board.generateBoard();
  }

  void handlePossibleMatch(int pos_1, int pos_2) {
    setState(() {
      print(
          "type_1: ${board.positionForType[pos_1]}, type_2: ${board.positionForType[pos_2]}");
      if (board.positionForType[pos_1] == board.positionForType[pos_2] &&
          pos_1 != pos_2) {
        gameController.updateScore();
        if (gameController.points == board.numSingleCards) {
          gameController.finishGame(context);
        }
        const twentyMillis = const Duration(milliseconds: 130);
        new Timer(twentyMillis, () => isCard[pos_1] = isCard[pos_2] = false);
      } else {
        const twentyMillis = const Duration(milliseconds: 300);
        new Timer(twentyMillis, () {
          isFlippedCard[pos_1] = isFlippedCard[pos_2] = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Build BoardWidget");

    if (gameController.gameInit) {
      initBoardData(8);
      gameController.gameInit = false;
    }

    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[getCard(0), getCard(1), getCard(2), getCard(3)],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[getCard(4), getCard(5), getCard(6), getCard(7)],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[getCard(8), getCard(9), getCard(10), getCard(11)],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[getCard(12), getCard(13), getCard(14), getCard(15)],
      ),
    ]);
  }

  Widget getCard(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isCard[i]) {
            isFlippedCard[i] = !isFlippedCard[i];

            if (lastFlipped != i && isFlippedCard[i]) {
              numFlippedCards++;
            }

            if (numFlippedCards == 2) {
              handlePossibleMatch(i, lastFlipped);
              numFlippedCards = 0;
              lastFlipped = -1;
            } else {
              lastFlipped = i;
            }
          }

          print(
              "Premuto $i, flipped = ${isFlippedCard[i]}, last_flipped = $lastFlipped");
        });
      },
      child: Visibility(
        visible: isCard[i] && gameController.gameStarted,
        child: Visibility(
          visible: !isFlippedCard[i],
          child: Container(
            width: MediaQuery.of(context).size.width * cardWidthPercentage,
            height: MediaQuery.of(context).size.height * cardHeightPercentage,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            foregroundDecoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          replacement: Container(
            width: MediaQuery.of(context).size.width * cardWidthPercentage,
            height: MediaQuery.of(context).size.height * cardHeightPercentage,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Image(
              image: AssetImage('img/emoji_${board.positionForType[i]}.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        replacement: Container(
          width: MediaQuery.of(context).size.width * cardWidthPercentage,
          height: MediaQuery.of(context).size.height * cardHeightPercentage,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        ),
      ),
    );
  }
}
