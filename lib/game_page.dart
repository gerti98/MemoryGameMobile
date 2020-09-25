import 'dart:async';
import 'package:auction_handler/backend.dart';
import 'package:flutter/material.dart';
import 'BoardWidget.dart';
import 'utils.dart';
import 'backend.dart';
import 'base_widget_ui.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isButtonDisabled = false;
  Timer t;
  BoardWidget boardWidget = BoardWidget();

  void startTimer() {
    gameController.startGame();
    const oneSec = const Duration(seconds: 1);
    setState(() {
      _isButtonDisabled = true;
    });
    gameController.timer = Timer.periodic(oneSec, (t) {
      setState(() {
        if (gameController.remainingTime > 0)
          gameController.remainingTime--;
        else {
          gameController.finishGame(context);
        }
      });
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (gameController.gameFinished) {
      gameController.gameFinished = false;
      _isButtonDisabled = false;
      if (gameController.timer != null) gameController.timer.cancel();
    }

    return Scaffold(
      drawer: DrawerAfterLogin(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              authService.signOutWithGoogle();
              Navigator.pushNamed(context, '/login');
              print('LOGOUT');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
                          child: Text(
                            'SCORE',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${gameController.points}',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
                          child: Text(
                            'TIME',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${gameController.remainingTime}',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BoardWidget(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: const EdgeInsets.all(13.0),
      child: new RaisedButton(
        onPressed: _isButtonDisabled ? null : startTimer,
        color: Colors.blue,
        textColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'NEW GAME',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
