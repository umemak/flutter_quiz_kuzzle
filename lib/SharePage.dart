// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import 'PresenterPage.dart';

class SharePage extends StatefulWidget {
  SharePage(this.id, this.title, this.code, this.gameid);
  final String id;
  final String title;
  final String code;
  final String gameid;

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    final testUrl =
        "${window.location.protocol}//${window.location.hostname}:${window.location.port}/#/entry?code=" +
            widget.gameid;
    return Scaffold(
      appBar: AppBar(
        title: Text("問題共有"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Text(widget.title),
              const SizedBox(height: 8),
              QrImage(
                data: testUrl,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(testUrl),
                  IconButton(
                    onPressed: () async {
                      final data = ClipboardData(text: testUrl);
                      await Clipboard.setData(data);
                    },
                    icon: Icon(Icons.content_copy),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('開始'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('games')
                        .doc(widget.gameid)
                        .update({
                      'status': 1,
                      'current': 1,
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PresenterPage(widget.id, widget.gameid);
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('games/${widget.gameid}/members')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      return ListView(
                        children: documents.map((document) {
                          return Card(
                            child: CheckboxListTile(
                              title: Text(document['name']),
                              onChanged: (bool? value) async {
                                await FirebaseFirestore.instance
                                    .collection(
                                        'games/${widget.gameid}/members')
                                    .doc(document['uid'])
                                    .update({
                                  'joined': value,
                                });
                              },
                              value: document['joined'],
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: Text("受付中..."),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
