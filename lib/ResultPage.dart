import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'TopPage.dart';
import 'UserState.dart';

class ResultPage extends StatefulWidget {
  ResultPage(this.gameid);
  final String gameid;
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("結果発表"),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('games/${widget.gameid}/members')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                children: documents.map((document) {
                  return Card(
                    child: ListTile(
                      leading: Text("位"),
                      title: Text(document['name']),
                      subtitle: Text(document['point'] + "points"),
                    ),
                  );
                }).toList(),
              );
            }
            return Center(
              child: Text("読み込み中..."),
            );
          },
        ),
      ),
    );
  }
}
