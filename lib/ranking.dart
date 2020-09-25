import 'package:auction_handler/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'base_widget_ui.dart';
import 'backend.dart';

class Record {
  final String displayName;
  final String photoUrl;
  final int score;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        assert(map['photoURL'] != null),
        assert(map['score'] != null),
        displayName = map['displayName'],
        photoUrl = map['photoURL'],
        score = map['score'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$displayName:$score:$photoUrl>";
}

class Ranking extends StatelessWidget {
  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    int index = 1;
    return snapshot
        .map((data) => _buildListItem(context, data, index++))
        .toList();
  }

  DataRow _buildListItem(
      BuildContext context, DocumentSnapshot data, int index) {
    final record = Record.fromSnapshot(data);

    return DataRow(
      cells: [
        DataCell(
          Text(
            '$index',
            style: TextStyle(fontSize: 18),
          ),
        ),
        DataCell(
          Container(
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(record.photoUrl),
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            record.displayName,
            style: TextStyle(fontSize: 18),
          ),
        ),
        DataCell(Text(
          record.score.toString(),
          style: TextStyle(fontSize: 18),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerAfterLogin(),
      appBar: AppBar(
        title: Text('Ranking'),
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
      body: StreamBuilder(
        stream: authService.db
            .collection('scores')
            .orderBy('score', descending: true)
            .limit(rowsToLoad)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading ...");
          } else {
            // return ListView.builder(
            //   itemExtent: 80.0,
            //   itemCount: snapshot.data.documents.length,
            //   itemBuilder: (context, index) {
            //     return _buildListItem(context, snapshot.data.documents[index]);
            //   },
            // );

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      numeric: true,
                      label: Center(
                        child: Text('#'),
                      ),
                    ),
                    DataColumn(label: Text(' ')),
                    DataColumn(
                      label: Center(
                        child: Text('Name'),
                      ),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Center(
                        child: Text('Score'),
                      ),
                    ),
                  ],
                  rows: _buildList(context, snapshot.data.documents),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
