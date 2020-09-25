import 'package:auction_handler/backend.dart';
import 'package:flutter/material.dart';

class GameController {
  bool gameStarted = false;
  bool gameInit = false;
  bool gameFinished = false;
  int points;
  int remainingTime;
  int startingTime;
  var timer;

  GameController(int time) {
    startingTime = time;
    remainingTime = time;
    points = 0;
  }

  void updateScore() {
    points++;
  }

  void startGame() {
    gameStarted = true;
    gameInit = true;
    points = 0;
    remainingTime = startingTime;
  }

  void finishGame(BuildContext context) {
    gameStarted = false;
    gameFinished = true;
    String title = 'YOU WON';
    if (points != 8) title = 'YOU LOSE';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$title'),
        content: Text('Score: $points'),
        actions: [
          FlatButton(
            onPressed: () {
              if (points == 8)
                authService.updateScoreData(
                    authService.googleSignInAccount, remainingTime);
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void finishGameNoFocus() {
    gameStarted = false;
    gameFinished = true;
    if (timer != null) timer.cancel();
  }
}
