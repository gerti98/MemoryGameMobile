import 'package:auction_handler/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base_widget_ui.dart';
import 'backend.dart';
import 'utils.dart';

class Account extends StatefulWidget {
  Account({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String textToSent;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerAfterLogin(),
      appBar: AppBar(
        title: Text('Account'),
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      color: Colors.lightBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    authService.googleSignInAccount.photoUrl),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    authService.googleSignInAccount.displayName,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    authService.googleSignInAccount.email,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.lightBlue,
                      margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('MATCH PLAYED',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          StreamBuilder(
                            stream: authService.db
                                .collection('scores')
                                .where('uid',
                                    isEqualTo:
                                        authService.googleSignInAccount.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              String text;
                              if (!snapshot.hasData)
                                text = '0';
                              else
                                text =
                                    snapshot.data.documents.length.toString();
                              return Text(
                                text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: Colors.white),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.lightBlue,
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'BEST SCORE',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          StreamBuilder(
                            stream: authService.db
                                .collection('scores')
                                .where('uid',
                                    isEqualTo:
                                        authService.googleSignInAccount.id)
                                .orderBy('score', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              String text;
                              if (!snapshot.hasData)
                                text = '...';
                              else if (snapshot.data.documents.length > 0)
                                text = snapshot.data.documents[0]
                                    .data()['score']
                                    .toString();
                              else
                                text = '0';

                              return Text(
                                text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    color: Colors.white),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                color: Colors.lightBlue,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'OPZIONI',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.blue),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Numero Campi Classifica',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        valueRowsToLoad.toStringAsFixed(0),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Slider(
                value: valueRowsToLoad,
                min: 20,
                max: 200,
                divisions: 9,
                onChanged: (value) {
                  setState(() {
                    valueRowsToLoad = value;
                    rowsToLoad = value.toInt();
                    print(valueRowsToLoad);
                  });
                },
              ),
              Divider(
                thickness: 2,
                color: Colors.lightBlue,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    'EXTRA',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.blue),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Messaggio Amorevole per lo sviluppatore',
                        labelText: 'Feedback',
                      ),
                      validator: (String value) {
                        return value.isEmpty ? 'Scrivi Qualcosa' : null;
                      },
                      onSaved: (String value) {
                        textToSent = value;
                      },
                      maxLines: 3,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            _formKey.currentState.save();
                            authService.updateMessageData(
                                authService.googleSignInAccount, textToSent);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Messaggio inviato')));
                          }
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
