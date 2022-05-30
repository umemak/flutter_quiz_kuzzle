import 'package:flutter/material.dart';

class PresenterResultPage extends StatefulWidget {
  PresenterResultPage(this.gameid, this.testid);
  final String gameid;
  final String testid;
  @override
  _PresenterResultPageState createState() => _PresenterResultPageState();
}

class _PresenterResultPageState extends State<PresenterResultPage> {
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
