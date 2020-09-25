import 'package:auction_handler/utils.dart';
import 'package:flutter/material.dart';
import 'backend.dart';

class DrawerAfterLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          LoginHeader(),
          ListTile(
            title: Text('Game'),
            onTap: () {
              // authService.updateScoreData(authService.googleSignInAccount, 10);
              gameController.finishGameNoFocus();
              Navigator.pushNamed(context, '/game');
              print("GAME");
            },
          ),
          ListTile(
            title: Text('Ranking'),
            onTap: () {
              gameController.finishGameNoFocus();
              Navigator.pushNamed(context, '/ranking');
              print("RANKING");
            },
          ),
          ListTile(
            title: Text('Account'),
            onTap: () {
              gameController.finishGameNoFocus();
              // authService.updateScoreData(authService.googleSignInAccount, 8);
              Navigator.pushNamed(context, '/account');
              print("ACCOUNT");
            },
          ),
          // LoginButton(),
        ],
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image:
                    new NetworkImage(authService.googleSignInAccount.photoUrl),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text(authService.googleSignInAccount.displayName),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(authService.googleSignInAccount.email),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }
}
