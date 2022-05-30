import 'package:flutter/material.dart';
import 'PresenterResultPage.dart';

class PresenterPage extends StatefulWidget {
  PresenterPage(this.testid, this.gameid);
  final String testid;
  final String gameid;

  @override
  _PresenterPageState createState() => _PresenterPageState();
}

class _PresenterPageState extends State<PresenterPage> {
  int current = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主催者用ページ"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(32),
              height: 1000,
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('tests')
                    .doc(widget.testid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('エラー'),
                    );
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Center(
                      child: Text('指定した問題が見つかりません'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    var _qTitleController = []..length = 11;
                    var _qItem1Controller = []..length = 11;
                    var _qItem2Controller = []..length = 11;
                    var _qItem3Controller = []..length = 11;
                    var _qItem4Controller = []..length = 11;
                    var _qAnswerController = []..length = 11;
                    for (var i = 1; i <= 10; i++) {
                      var ii = "q" + i.toString().padLeft(2, "0");
                      _qTitleController[i] = data[ii + 'Title'] ?? "";
                      _qItem1Controller[i] = data[ii + 'Item1'] ?? "";
                      _qItem2Controller[i] = data[ii + 'Item2'] ?? "";
                      _qItem3Controller[i] = data[ii + 'Item3'] ?? "";
                      _qItem4Controller[i] = data[ii + 'Item4'] ?? "";
                      _qAnswerController[i] = data[ii + 'Answer'] ?? "";
                    }
                    RadioListTile makeRadioListTile(String text, String value) {
                      return new RadioListTile(
                        title: Text(text),
                        value: value,
                        groupValue: '',
                        onChanged: null,
                      );
                    }

                    Card makeCard(int idx) {
                      return Card(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Theme.of(context).primaryColor,
                              width: double.infinity,
                              child: Text(
                                "第 ${idx.toString()} 問",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                _qTitleController[idx],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            makeRadioListTile(_qItem1Controller[idx], "1"),
                            const SizedBox(height: 8),
                            makeRadioListTile(_qItem2Controller[idx], "2"),
                            const SizedBox(height: 8),
                            makeRadioListTile(_qItem3Controller[idx], "3"),
                            const SizedBox(height: 8),
                            makeRadioListTile(_qItem4Controller[idx], "4"),
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: Column(
                        children: <Widget>[
                          // makeCard(current),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  color: Theme.of(context).primaryColor,
                                  width: double.infinity,
                                  child: Text(
                                    "第 ${current.toString()} 問",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    _qTitleController[current],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                makeRadioListTile(
                                    _qItem1Controller[current], "1"),
                                const SizedBox(height: 8),
                                makeRadioListTile(
                                    _qItem2Controller[current], "2"),
                                const SizedBox(height: 8),
                                makeRadioListTile(
                                    _qItem3Controller[current], "3"),
                                const SizedBox(height: 8),
                                makeRadioListTile(
                                    _qItem4Controller[current], "4"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("回答表示"),
                              onPressed: () async {
                                // 正解者にポイント付与
                                final querySnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('games')
                                    .doc(widget.gameid)
                                    .collection('members')
                                    .get();
                                final queryDocSnapshot = querySnapshot.docs;
                                for (final snapshot in queryDocSnapshot) {
                                  final data = snapshot.data();
                                  print(data);
                                  final ans = data["a$current"];
                                  if (_qAnswerController[current] == ans) {
                                    await FirebaseFirestore.instance
                                        .collection(
                                            'games/${widget.gameid}/members')
                                        .doc(data["uid"])
                                        .update(
                                      {
                                        'point': data['point'] + 1,
                                      },
                                    );
                                  }
                                }
                                // ステータス更新
                                await FirebaseFirestore.instance
                                    .collection('games')
                                    .doc(widget.gameid)
                                    .update({
                                  'status': 2,
                                  'current': current,
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.navigate_next),
                              label: Text("つぎへ"),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('games')
                                    .doc(widget.gameid)
                                    .update({
                                  'status': 1,
                                  'current': current + 1,
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PresenterPage(
                                          widget.testid, widget.gameid);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("結果発表"),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('games')
                                    .doc(widget.gameid)
                                    .update({
                                  'status': 3,
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PresenterResultPage(
                                          widget.testid, widget.gameid);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('games/${widget.gameid}/members')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<DocumentSnapshot> documents =
                                      snapshot.data!.docs;
                                  return Expanded(
                                    child: ListView(
                                      children: documents.map((document) {
                                        print("doc: " + document['name']);
                                        return ListTile(
                                          title: Text(document['name'] +
                                              " : " +
                                              document['a$current']),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                                return Center(
                                  child: Text("回答受付中..."),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // データが読込中の場合
                  return Center(
                    child: Text('読込中...'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
